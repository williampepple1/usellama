#ifndef OLLAMACLIENT_H
#define OLLAMACLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>
#include <QQmlEngine>

class OllamaClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged)
    Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)
    Q_PROPERTY(QStringList availableModels READ availableModels NOTIFY availableModelsChanged)
    Q_PROPERTY(QString currentModel READ currentModel WRITE setCurrentModel NOTIFY currentModelChanged)

public:
    explicit OllamaClient(QObject *parent = nullptr);

    QString baseUrl() const { return m_baseUrl; }
    void setBaseUrl(const QString &url);

    bool isConnected() const { return m_connected; }

    QStringList availableModels() const { return m_availableModels; }

    QString currentModel() const { return m_currentModel; }
    void setCurrentModel(const QString &model);

    Q_INVOKABLE void checkConnection();
    Q_INVOKABLE void fetchModels();
    Q_INVOKABLE void sendChatMessage(const QJsonArray &messages, const QJsonArray &tools = QJsonArray());
    Q_INVOKABLE void cancelRequest();

signals:
    void baseUrlChanged();
    void connectedChanged();
    void availableModelsChanged();
    void currentModelChanged();
    void streamToken(const QString &token);
    void streamToolCall(const QJsonObject &toolCall);
    void responseFinished(const QJsonObject &fullResponse);
    void errorOccurred(const QString &error);

private slots:
    void onStreamReadyRead();
    void onStreamFinished();

private:
    QUrl apiUrl(const QString &endpoint) const;

    QNetworkAccessManager *m_nam;
    QNetworkReply *m_activeReply = nullptr;
    QString m_baseUrl;
    bool m_connected = false;
    QStringList m_availableModels;
    QString m_currentModel;
    QByteArray m_streamBuffer;
    QString m_accumulatedContent;
    QJsonArray m_accumulatedToolCalls;
};

#endif // OLLAMACLIENT_H
