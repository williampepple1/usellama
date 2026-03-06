#include "OllamaClient.h"

OllamaClient::OllamaClient(QObject *parent)
    : QObject(parent)
    , m_nam(new QNetworkAccessManager(this))
    , m_baseUrl("http://localhost:11434")
{
}

void OllamaClient::setBaseUrl(const QString &url)
{
    if (m_baseUrl != url) {
        m_baseUrl = url;
        emit baseUrlChanged();
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

void OllamaClient::checkConnection()
{
    QNetworkRequest req(apiUrl("/api/tags"));
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
    QNetworkRequest req(apiUrl("/api/tags"));
    QNetworkReply *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) {
            emit errorOccurred("Failed to fetch models: " + reply->errorString());
            return;
        }
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonArray models = doc.object()["models"].toArray();
        m_availableModels.clear();
        for (const QJsonValue &v : models) {
            m_availableModels.append(v.toObject()["name"].toString());
        }
        emit availableModelsChanged();
        if (!m_availableModels.isEmpty() && m_currentModel.isEmpty()) {
            setCurrentModel(m_availableModels.first());
        }
    });
}

void OllamaClient::sendChatMessage(const QJsonArray &messages, const QJsonArray &tools)
{
    cancelRequest();

    QJsonObject body;
    body["model"] = m_currentModel;
    body["messages"] = messages;
    body["stream"] = true;
    if (!tools.isEmpty())
        body["tools"] = tools;

    QNetworkRequest req(apiUrl("/api/chat"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

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

void OllamaClient::onStreamFinished()
{
    if (!m_activeReply) return;

    if (m_activeReply->error() != QNetworkReply::NoError &&
        m_activeReply->error() != QNetworkReply::OperationCanceledError) {
        emit errorOccurred(m_activeReply->errorString());
    }

    QJsonObject fullResponse;
    fullResponse["content"] = m_accumulatedContent;
    if (!m_accumulatedToolCalls.isEmpty())
        fullResponse["tool_calls"] = m_accumulatedToolCalls;

    emit responseFinished(fullResponse);

    m_activeReply->deleteLater();
    m_activeReply = nullptr;
}
