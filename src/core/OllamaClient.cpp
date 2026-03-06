#include "OllamaClient.h"

OllamaClient::OllamaClient(QObject *parent)
    : QObject(parent)
    , m_nam(new QNetworkAccessManager(this))
    , m_baseUrl("http://localhost:11434")
    , m_reconnectTimer(new QTimer(this))
{
    m_reconnectTimer->setInterval(10000);
    connect(m_reconnectTimer, &QTimer::timeout, this, &OllamaClient::checkConnection);
    startAutoReconnect();
}

void OllamaClient::setBaseUrl(const QString &url)
{
    QString cleanUrl = url.trimmed();
    while (cleanUrl.endsWith('/'))
        cleanUrl.chop(1);
    if (m_baseUrl != cleanUrl) {
        m_baseUrl = cleanUrl;
        emit baseUrlChanged();
        m_connected = false;
        emit connectedChanged();
        checkConnection();
    }
}

void OllamaClient::setApiKey(const QString &key)
{
    if (m_apiKey != key) {
        m_apiKey = key;
        emit apiKeyChanged();
        checkConnection();
    }
}

void OllamaClient::setApiMode(const QString &mode)
{
    if (m_apiMode != mode) {
        m_apiMode = mode;
        emit apiModeChanged();
        m_connected = false;
        emit connectedChanged();
        checkConnection();
    }
}

void OllamaClient::setCurrentModel(const QString &model)
{
    if (m_currentModel != model) {
        m_currentModel = model;
        emit currentModelChanged();
    }
}

QUrl OllamaClient::apiUrl(const QString &endpoint) const
{
    return QUrl(m_baseUrl + endpoint);
}

void OllamaClient::applyAuth(QNetworkRequest &req) const
{
    if (!m_apiKey.isEmpty()) {
        req.setRawHeader("Authorization", ("Bearer " + m_apiKey).toUtf8());
    }
}

void OllamaClient::checkConnection()
{
    QString endpoint = isCloudMode() ? "/v1/models" : "/api/tags";
    QNetworkRequest req(apiUrl(endpoint));
    applyAuth(req);
    QNetworkReply *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        bool wasConnected = m_connected;
        m_connected = (reply->error() == QNetworkReply::NoError);
        if (m_connected != wasConnected)
            emit connectedChanged();
        if (m_connected)
            fetchModels();
    });
}

void OllamaClient::fetchModels()
{
    QString endpoint = isCloudMode() ? "/v1/models" : "/api/tags";
    QNetworkRequest req(apiUrl(endpoint));
    applyAuth(req);
    QNetworkReply *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) {
            emit errorOccurred("Failed to fetch models: " + reply->errorString());
            return;
        }
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        m_availableModels.clear();

        if (isCloudMode()) {
            QJsonArray models = doc.object()["data"].toArray();
            for (const QJsonValue &v : models) {
                m_availableModels.append(v.toObject()["id"].toString());
            }
        } else {
            QJsonArray models = doc.object()["models"].toArray();
            for (const QJsonValue &v : models) {
                m_availableModels.append(v.toObject()["name"].toString());
            }
        }

        emit availableModelsChanged();
        if (!m_availableModels.isEmpty() && m_currentModel.isEmpty()) {
            setCurrentModel(m_availableModels.first());
        }
    });
}

void OllamaClient::sendChatMessage(const QJsonArray &messages, const QJsonArray &tools)
{
    if (m_currentModel.isEmpty()) {
        emit errorOccurred("No model selected. Open Settings and check your Ollama connection, or select a model from the dropdown.");
        return;
    }

    cancelRequest();

    QJsonObject body;
    body["model"] = m_currentModel;
    body["messages"] = messages;
    body["stream"] = true;

    if (isCloudMode()) {
        if (!tools.isEmpty()) {
            QJsonArray openaiTools;
            for (const QJsonValue &t : tools) {
                QJsonObject tool;
                tool["type"] = "function";
                tool["function"] = t.toObject();
                openaiTools.append(tool);
            }
            body["tools"] = openaiTools;
        }
    } else {
        if (!tools.isEmpty())
            body["tools"] = tools;
    }

    QString endpoint = isCloudMode() ? "/v1/chat/completions" : "/api/chat";
    QNetworkRequest req(apiUrl(endpoint));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    applyAuth(req);

    m_streamBuffer.clear();
    m_accumulatedContent.clear();
    m_accumulatedToolCalls = QJsonArray();

    m_activeReply = m_nam->post(req, QJsonDocument(body).toJson());
    connect(m_activeReply, &QNetworkReply::readyRead, this, &OllamaClient::onStreamReadyRead);
    connect(m_activeReply, &QNetworkReply::finished, this, &OllamaClient::onStreamFinished);
}

void OllamaClient::cancelRequest()
{
    if (m_activeReply) {
        m_activeReply->abort();
        m_activeReply->deleteLater();
        m_activeReply = nullptr;
    }
}

void OllamaClient::onStreamReadyRead()
{
    if (!m_activeReply) return;

    m_streamBuffer.append(m_activeReply->readAll());

    while (true) {
        int idx = m_streamBuffer.indexOf('\n');
        if (idx < 0) break;

        QByteArray line = m_streamBuffer.left(idx).trimmed();
        m_streamBuffer.remove(0, idx + 1);

        if (line.isEmpty()) continue;

        if (isCloudMode()) {
            // OpenAI SSE format: "data: {...}"
            if (line.startsWith("data: ")) {
                line = line.mid(6);
            } else {
                continue;
            }
            if (line == "[DONE]") continue;

            QJsonDocument doc = QJsonDocument::fromJson(line);
            if (doc.isNull()) continue;

            QJsonObject obj = doc.object();
            QJsonArray choices = obj["choices"].toArray();
            if (choices.isEmpty()) continue;

            QJsonObject choice = choices[0].toObject();
            QJsonObject delta = choice["delta"].toObject();

            QString content = delta["content"].toString();
            if (!content.isEmpty()) {
                m_accumulatedContent += content;
                emit streamToken(content);
            }

            QJsonArray toolCalls = delta["tool_calls"].toArray();
            if (!toolCalls.isEmpty()) {
                for (const QJsonValue &tc : toolCalls) {
                    QJsonObject tcObj = tc.toObject();
                    m_accumulatedToolCalls.append(tcObj);
                    emit streamToolCall(tcObj);
                }
            }
        } else {
            // Native Ollama format: one JSON object per line
            QJsonDocument doc = QJsonDocument::fromJson(line);
            if (doc.isNull()) continue;

            QJsonObject obj = doc.object();
            QJsonObject message = obj["message"].toObject();
            QString content = message["content"].toString();

            if (!content.isEmpty()) {
                m_accumulatedContent += content;
                emit streamToken(content);
            }

            QJsonArray toolCalls = message["tool_calls"].toArray();
            if (!toolCalls.isEmpty()) {
                for (const QJsonValue &tc : toolCalls) {
                    m_accumulatedToolCalls.append(tc);
                    emit streamToolCall(tc.toObject());
                }
            }
        }
    }
}

void OllamaClient::onStreamFinished()
{
    if (!m_activeReply) return;

    if (m_activeReply->error() != QNetworkReply::NoError &&
        m_activeReply->error() != QNetworkReply::OperationCanceledError) {
        QString errMsg = "Error transferring " + m_activeReply->url().toString();
        int status = m_activeReply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QByteArray body = m_activeReply->readAll();
        if (status > 0) {
            errMsg += " (HTTP " + QString::number(status) + ")";
        }
        if (!body.isEmpty()) {
            QJsonDocument doc = QJsonDocument::fromJson(body);
            if (doc.isObject() && doc.object().contains("error")) {
                errMsg += ": " + doc.object()["error"].toString();
            } else {
                QString bodyStr = QString::fromUtf8(body).left(200).trimmed();
                if (!bodyStr.isEmpty())
                    errMsg += ": " + bodyStr;
            }
        }
        emit errorOccurred(errMsg);
    }

    QJsonObject fullResponse;
    fullResponse["content"] = m_accumulatedContent;
    if (!m_accumulatedToolCalls.isEmpty())
        fullResponse["tool_calls"] = m_accumulatedToolCalls;

    emit responseFinished(fullResponse);

    m_activeReply->deleteLater();
    m_activeReply = nullptr;
}

void OllamaClient::startAutoReconnect()
{
    if (!m_reconnectTimer->isActive())
        m_reconnectTimer->start();
}

void OllamaClient::stopAutoReconnect()
{
    m_reconnectTimer->stop();
}
