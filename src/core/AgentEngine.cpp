#include "AgentEngine.h"
#include "OllamaClient.h"
#include "AgentTools.h"

AgentEngine::AgentEngine(QObject *parent)
    : QObject(parent)
{
}

void AgentEngine::setOllamaClient(OllamaClient *client)
{
    if (m_client) {
        disconnect(m_client, nullptr, this, nullptr);
    }
    m_client = client;
    connect(m_client, &OllamaClient::streamToken, this, &AgentEngine::onStreamToken);
    connect(m_client, &OllamaClient::streamToolCall, this, &AgentEngine::onStreamToolCall);
    connect(m_client, &OllamaClient::responseFinished, this, &AgentEngine::onResponseFinished);
    connect(m_client, &OllamaClient::errorOccurred, this, &AgentEngine::onError);
}

void AgentEngine::setAgentTools(AgentTools *tools)
{
    m_tools = tools;
}

void AgentEngine::sendMessage(const QString &userMessage, const QString &workspacePath)
{
    if (m_running) return;

    m_workspacePath = workspacePath;
    m_running = true;
    m_currentIteration = 0;
    emit runningChanged();

    if (m_conversationHistory.isEmpty()) {
        QJsonObject sysMsg;
        sysMsg["role"] = "system";
        sysMsg["content"] = systemPrompt(workspacePath);
        m_conversationHistory.append(sysMsg);
    }

    QJsonObject userMsg;
    userMsg["role"] = "user";
    userMsg["content"] = userMessage;
    m_conversationHistory.append(userMsg);

    executeAgentLoop();
}

void AgentEngine::cancelAgent()
{
    if (m_client) m_client->cancelRequest();
    m_running = false;
    emit runningChanged();
}

void AgentEngine::clearHistory()
{
    m_conversationHistory = QJsonArray();
}

void AgentEngine::executeAgentLoop()
{
    if (!m_client || !m_tools) return;

    m_currentIteration++;
    if (m_currentIteration > m_maxIterations) {
        emit agentError("Maximum iterations reached. Stopping agent loop.");
        m_running = false;
        emit runningChanged();
        return;
    }

    m_client->sendChatMessage(m_conversationHistory, m_tools->toolDefinitions());
}

void AgentEngine::onStreamToken(const QString &token)
{
    emit assistantToken(token);
}

void AgentEngine::onStreamToolCall(const QJsonObject &toolCall)
{
    QJsonObject function = toolCall["function"].toObject();
    QString name = function["name"].toString();
    QJsonObject args = function["arguments"].toObject();
    emit toolCallStarted(name, args);
}

void AgentEngine::onResponseFinished(const QJsonObject &fullResponse)
{
    QString content = fullResponse["content"].toString();
    QJsonArray toolCalls = fullResponse["tool_calls"].toArray();

    QJsonObject assistantMsg;
    assistantMsg["role"] = "assistant";
    if (!content.isEmpty())
        assistantMsg["content"] = content;
    if (!toolCalls.isEmpty())
        assistantMsg["tool_calls"] = toolCalls;
    m_conversationHistory.append(assistantMsg);

    if (!toolCalls.isEmpty() && m_tools) {
        for (const QJsonValue &tc : toolCalls) {
            QJsonObject toolCall = tc.toObject();
            QJsonObject function = toolCall["function"].toObject();
            QString name = function["name"].toString();
            QJsonObject args = function["arguments"].toObject();

            QString result = m_tools->executeTool(name, args);
            emit toolCallFinished(name, result);

            QJsonObject toolMsg;
            toolMsg["role"] = "tool";
            toolMsg["content"] = result;
            m_conversationHistory.append(toolMsg);
        }

        executeAgentLoop();
    } else {
        emit agentFinished(content);
        m_running = false;
        emit runningChanged();
    }
}

void AgentEngine::onError(const QString &error)
{
    emit agentError(error);
    m_running = false;
    emit runningChanged();
}

QString AgentEngine::systemPrompt(const QString &workspacePath) const
{
    return QString(
        "You are UseLlama, an expert AI coding assistant integrated into a desktop IDE. "
        "You help users with software engineering tasks by reading, writing, and editing code files, "
        "running shell commands, and navigating the project structure.\n\n"
        "The user's workspace is located at: %1\n\n"
        "You have access to the following tools:\n"
        "- read_file: Read the contents of a file\n"
        "- write_file: Create or overwrite a file\n"
        "- edit_file: Replace specific text in a file\n"
        "- list_directory: List files and directories in a path\n"
        "- delete_file: Delete a file or directory\n"
        "- run_command: Execute a shell command\n"
        "- search_files: Search for a regex pattern in files\n"
        "- create_directory: Create a directory\n\n"
        "Guidelines:\n"
        "1. Always explain what you plan to do before making changes.\n"
        "2. Use read_file to understand existing code before editing.\n"
        "3. Use edit_file for targeted changes rather than rewriting entire files.\n"
        "4. After making changes, briefly confirm what was done.\n"
        "5. If a task is unclear, ask for clarification.\n"
        "6. When running commands, explain the purpose first.\n"
        "7. Be concise but thorough in your explanations."
    ).arg(workspacePath);
}
