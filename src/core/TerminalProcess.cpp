#include "TerminalProcess.h"
#include <QCoreApplication>

TerminalProcess::TerminalProcess(QObject *parent)
    : QObject(parent)
{
}

void TerminalProcess::setWorkingDirectory(const QString &dir)
{
    if (m_workingDirectory != dir) {
        m_workingDirectory = dir;
        emit workingDirectoryChanged();
    }
}

void TerminalProcess::executeCommand(const QString &command)
{
    if (m_process) {
        if (m_process->state() != QProcess::NotRunning) {
            m_process->kill();
            m_process->waitForFinished(1000);
        }
        m_process->deleteLater();
    }

    m_process = new QProcess(this);
    if (!m_workingDirectory.isEmpty())
        m_process->setWorkingDirectory(m_workingDirectory);

    connect(m_process, &QProcess::readyReadStandardOutput, this, &TerminalProcess::onReadyReadStdout);
    connect(m_process, &QProcess::readyReadStandardError, this, &TerminalProcess::onReadyReadStderr);
    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &TerminalProcess::onProcessFinished);

    appendOutput("$ " + command + "\n");

#ifdef Q_OS_WIN
    m_process->start("cmd.exe", {"/c", command});
#else
    m_process->start("/bin/sh", {"-c", command});
#endif

    emit runningChanged();
}

void TerminalProcess::sendInput(const QString &input)
{
    if (m_process && m_process->state() == QProcess::Running) {
        m_process->write(input.toUtf8());
        m_process->write("\n");
    }
}

void TerminalProcess::killProcess()
{
    if (m_process && m_process->state() != QProcess::NotRunning) {
        m_process->kill();
    }
}

void TerminalProcess::clearOutput()
{
    m_output.clear();
    emit outputChanged();
}

QString TerminalProcess::runCommandSync(const QString &command, int timeoutMs)
{
    QProcess proc;
    if (!m_workingDirectory.isEmpty())
        proc.setWorkingDirectory(m_workingDirectory);

#ifdef Q_OS_WIN
    proc.start("cmd.exe", {"/c", command});
#else
    proc.start("/bin/sh", {"-c", command});
#endif

    if (!proc.waitForFinished(timeoutMs)) {
        proc.kill();
        return "Error: Command timed out after " + QString::number(timeoutMs / 1000) + " seconds";
    }

    QString stdoutStr = QString::fromUtf8(proc.readAllStandardOutput());
    QString stderrStr = QString::fromUtf8(proc.readAllStandardError());
    int exitCode = proc.exitCode();

    QString result = stdoutStr;
    if (!stderrStr.isEmpty())
        result += "\n[stderr]: " + stderrStr;
    if (exitCode != 0)
        result += "\n[exit code]: " + QString::number(exitCode);

    return result.trimmed();
}

void TerminalProcess::onReadyReadStdout()
{
    QString text = QString::fromUtf8(m_process->readAllStandardOutput());
    appendOutput(text);
}

void TerminalProcess::onReadyReadStderr()
{
    QString text = QString::fromUtf8(m_process->readAllStandardError());
    appendOutput(text);
}

void TerminalProcess::onProcessFinished(int exitCode, QProcess::ExitStatus)
{
    appendOutput("\n[Process exited with code " + QString::number(exitCode) + "]\n");
    emit runningChanged();
    emit commandFinished(exitCode);
}

void TerminalProcess::appendOutput(const QString &text)
{
    m_output += text;
    emit outputChanged();
    emit outputAppended(text);
}
