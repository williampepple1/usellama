#ifndef TERMINALPROCESS_H
#define TERMINALPROCESS_H

#include <QObject>
#include <QProcess>
#include <QQmlEngine>

class TerminalProcess : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString output READ output NOTIFY outputChanged)
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(QString workingDirectory READ workingDirectory WRITE setWorkingDirectory NOTIFY workingDirectoryChanged)

public:
    explicit TerminalProcess(QObject *parent = nullptr);

    QString output() const { return m_output; }
    bool isRunning() const { return m_process && m_process->state() != QProcess::NotRunning; }
    QString workingDirectory() const { return m_workingDirectory; }
    void setWorkingDirectory(const QString &dir);

    Q_INVOKABLE void executeCommand(const QString &command);
    Q_INVOKABLE void sendInput(const QString &input);
    Q_INVOKABLE void killProcess();
    Q_INVOKABLE void clearOutput();

    QString runCommandSync(const QString &command, int timeoutMs = 30000);

signals:
    void outputChanged();
    void outputAppended(const QString &text);
    void runningChanged();
    void workingDirectoryChanged();
    void commandFinished(int exitCode);

private slots:
    void onReadyReadStdout();
    void onReadyReadStderr();
    void onProcessFinished(int exitCode, QProcess::ExitStatus status);

private:
    void appendOutput(const QString &text);

    QProcess *m_process = nullptr;
    QString m_output;
    QString m_workingDirectory;
};

#endif // TERMINALPROCESS_H
