#ifndef CHATMESSAGE_H
#define CHATMESSAGE_H

#include <QString>
#include <QVariantMap>
#include <QVariantList>

struct ChatMessage {
    enum Role { System, User, Assistant, Tool };

    Role role;
    QString content;
    QString toolCallId;
    QVariantList toolCalls;

    QVariantMap toJson() const {
        QVariantMap msg;
        switch (role) {
        case System:    msg["role"] = "system"; break;
        case User:      msg["role"] = "user"; break;
        case Assistant:  msg["role"] = "assistant"; break;
        case Tool:      msg["role"] = "tool"; break;
        }
        msg["content"] = content;
        if (!toolCalls.isEmpty())
            msg["tool_calls"] = toolCalls;
        return msg;
    }

    static ChatMessage fromJson(const QVariantMap &json) {
        ChatMessage msg;
        QString role = json["role"].toString();
        if (role == "system")         msg.role = System;
        else if (role == "user")      msg.role = User;
        else if (role == "assistant") msg.role = Assistant;
        else if (role == "tool")      msg.role = Tool;

        msg.content = json["content"].toString();
        msg.toolCalls = json["tool_calls"].toList();
        return msg;
    }
};

#endif // CHATMESSAGE_H
