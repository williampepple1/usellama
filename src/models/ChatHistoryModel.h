#ifndef CHATHISTORYMODEL_H
#define CHATHISTORYMODEL_H

#include <QAbstractListModel>
#include <QQmlEngine>

class ChatHistoryModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum MessageRole {
        RoleType = Qt::UserRole + 1,
        ContentRole,
        IsStreamingRole,
        ToolNameRole,
        ToolArgsRole,
        ToolResultRole,
        TimestampRole
    };

    enum MessageType {
        UserMessage,
        AssistantMessage,
        ToolCallMessage,
        ErrorMessage
    };
    Q_ENUM(MessageType)

    explicit ChatHistoryModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addUserMessage(const QString &content);
    Q_INVOKABLE int addAssistantMessage(const QString &content = "");
    Q_INVOKABLE void appendToAssistant(int index, const QString &token);
    Q_INVOKABLE void finalizeAssistant(int index);
    Q_INVOKABLE void addToolCall(const QString &name, const QString &args, const QString &result);
    Q_INVOKABLE void addErrorMessage(const QString &content);
    Q_INVOKABLE void clear();

signals:
    void countChanged();

private:
    struct Message {
        MessageType type;
        QString content;
        bool isStreaming = false;
        QString toolName;
        QString toolArgs;
        QString toolResult;
        qint64 timestamp;
    };

    QVector<Message> m_messages;
};

#endif // CHATHISTORYMODEL_H
