#include "ChatHistoryModel.h"
#include <QDateTime>

ChatHistoryModel::ChatHistoryModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ChatHistoryModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_messages.size();
}

QVariant ChatHistoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_messages.size())
        return QVariant();

    const Message &msg = m_messages[index.row()];
    switch (role) {
    case RoleType: return msg.type;
    case ContentRole: return msg.content;
    case IsStreamingRole: return msg.isStreaming;
    case ToolNameRole: return msg.toolName;
    case ToolArgsRole: return msg.toolArgs;
    case ToolResultRole: return msg.toolResult;
    case TimestampRole: return msg.timestamp;
    default: return QVariant();
    }
}

QHash<int, QByteArray> ChatHistoryModel::roleNames() const
{
    return {
        {RoleType, "roleType"},
        {ContentRole, "content"},
        {IsStreamingRole, "isStreaming"},
        {ToolNameRole, "toolName"},
        {ToolArgsRole, "toolArgs"},
        {ToolResultRole, "toolResult"},
        {TimestampRole, "timestamp"}
    };
}

void ChatHistoryModel::addUserMessage(const QString &content)
{
    int row = m_messages.size();
    beginInsertRows(QModelIndex(), row, row);
    Message msg;
    msg.type = UserMessage;
    msg.content = content;
    msg.timestamp = QDateTime::currentMSecsSinceEpoch();
    m_messages.append(msg);
    endInsertRows();
    emit countChanged();
}

int ChatHistoryModel::addAssistantMessage(const QString &content)
{
    int row = m_messages.size();
    beginInsertRows(QModelIndex(), row, row);
    Message msg;
    msg.type = AssistantMessage;
    msg.content = content;
    msg.isStreaming = true;
    msg.timestamp = QDateTime::currentMSecsSinceEpoch();
    m_messages.append(msg);
    endInsertRows();
    emit countChanged();
    return row;
}

void ChatHistoryModel::appendToAssistant(int index, const QString &token)
{
    if (index < 0 || index >= m_messages.size()) return;
    m_messages[index].content += token;
    QModelIndex modelIdx = createIndex(index, 0);
    emit dataChanged(modelIdx, modelIdx, {ContentRole});
}

void ChatHistoryModel::finalizeAssistant(int index)
{
    if (index < 0 || index >= m_messages.size()) return;
    m_messages[index].isStreaming = false;
    QModelIndex modelIdx = createIndex(index, 0);
    emit dataChanged(modelIdx, modelIdx, {IsStreamingRole});
}

void ChatHistoryModel::addToolCall(const QString &name, const QString &args, const QString &result)
{
    int row = m_messages.size();
    beginInsertRows(QModelIndex(), row, row);
    Message msg;
    msg.type = ToolCallMessage;
    msg.toolName = name;
    msg.toolArgs = args;
    msg.toolResult = result;
    msg.timestamp = QDateTime::currentMSecsSinceEpoch();
    m_messages.append(msg);
    endInsertRows();
    emit countChanged();
}

void ChatHistoryModel::addErrorMessage(const QString &content)
{
    int row = m_messages.size();
    beginInsertRows(QModelIndex(), row, row);
    Message msg;
    msg.type = ErrorMessage;
    msg.content = content;
    msg.timestamp = QDateTime::currentMSecsSinceEpoch();
    m_messages.append(msg);
    endInsertRows();
    emit countChanged();
}

void ChatHistoryModel::clear()
{
    beginResetModel();
    m_messages.clear();
    endResetModel();
    emit countChanged();
}
