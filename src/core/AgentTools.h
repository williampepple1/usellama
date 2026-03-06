#ifndef AGENTTOOLS_H
#define AGENTTOOLS_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QQmlEngine>

class FileSystemManager;
class TerminalProcess;

class AgentTools : public QObject
{
    Q_OBJECT

public:
    explicit AgentTools(QObject *parent = nullptr);

    void setFileSystemManager(FileSystemManager *fsm);
    void setTerminalProcess(TerminalProcess *tp);

    QJsonArray toolDefinitions() const;
    Q_INVOKABLE QString executeTool(const QString &name, const QJsonObject &arguments);

signals:
    void toolExecuted(const QString &name, const QJsonObject &args, const QString &result);

private:
    QString readFile(const QJsonObject &args);
    QString writeFile(const QJsonObject &args);
    QString editFile(const QJsonObject &args);
    QString listDirectory(const QJsonObject &args);
    QString deleteFile(const QJsonObject &args);
    QString runCommand(const QJsonObject &args);
    QString searchFiles(const QJsonObject &args);
    QString createDirectory(const QJsonObject &args);

    FileSystemManager *m_fsm = nullptr;
    TerminalProcess *m_terminal = nullptr;
};

#endif // AGENTTOOLS_H
