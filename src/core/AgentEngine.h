#ifndef AGENTENGINE_H
#define AGENTENGINE_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QQmlEngine>

class OllamaClient;
class AgentTools;

class AgentEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)

public:
    explicit AgentEngine(QObject *parent = nullptr);

    void setOllamaClient(OllamaClient *client);
    void setAgentTools(AgentTools *tools);

    bool isRunning() const { return m_running; }

    Q_INVOKABLE void sendMessage(const QString &userMessage, const QString &workspacePath);
    Q_INVOKABLE void cancelAgent();
    Q_INVOKABLE void clearHistory();

signals:
    void runningChanged();
    void assistantToken(const QString &token);
    void toolCallStarted(const QString &name, const QJsonObject &args);
    void toolCallFinished(const QString &name, const QString &result);
    void agentFinished(const QString &fullResponse);
    void agentError(const QString &error);

private slots:
    void onStreamToken(const QString &token);
    void onStreamToolCall(const QJsonObject &toolCall);
    void onResponseFinished(const QJsonObject &fullResponse);
    void onError(const QString &error);

private:
    void executeAgentLoop();
    QString systemPrompt(const QString &workspacePath) const;

    OllamaClient *m_client = nullptr;
    AgentTools *m_tools = nullptr;
    QJsonArray m_conversationHistory;
    bool m_running = false;
    int m_maxIterations = 20;
    int m_currentIteration = 0;
    QString m_workspacePath;
};

#endif // AGENTENGINE_H
