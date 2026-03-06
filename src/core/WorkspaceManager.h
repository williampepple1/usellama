#ifndef WORKSPACEMANAGER_H
#define WORKSPACEMANAGER_H

#include <QObject>
#include <QStringList>
#include <QQmlEngine>
#include <QSettings>

class WorkspaceManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList recentWorkspaces READ recentWorkspaces NOTIFY recentWorkspacesChanged)
    Q_PROPERTY(QString currentWorkspace READ currentWorkspace NOTIFY currentWorkspaceChanged)

public:
    explicit WorkspaceManager(QObject *parent = nullptr);

    QStringList recentWorkspaces() const { return m_recentWorkspaces; }
    QString currentWorkspace() const { return m_currentWorkspace; }

    Q_INVOKABLE void openWorkspace(const QString &path);
    Q_INVOKABLE void removeFromRecent(const QString &path);
    Q_INVOKABLE void clearRecent();
    Q_INVOKABLE QString workspaceName(const QString &path) const;

signals:
    void recentWorkspacesChanged();
    void currentWorkspaceChanged();

private:
    void loadRecent();
    void saveRecent();

    QSettings m_settings;
    QStringList m_recentWorkspaces;
    QString m_currentWorkspace;
    static const int MAX_RECENT = 10;
};

#endif // WORKSPACEMANAGER_H
