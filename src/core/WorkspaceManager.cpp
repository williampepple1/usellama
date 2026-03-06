#include "WorkspaceManager.h"
#include <QDir>
#include <QFileInfo>

WorkspaceManager::WorkspaceManager(QObject *parent)
    : QObject(parent)
    , m_settings("UseLlama", "UseLlama")
{
    loadRecent();
}

void WorkspaceManager::openWorkspace(const QString &path)
{
    m_currentWorkspace = path;
    emit currentWorkspaceChanged();

    m_recentWorkspaces.removeAll(path);
    m_recentWorkspaces.prepend(path);
    if (m_recentWorkspaces.size() > MAX_RECENT)
        m_recentWorkspaces = m_recentWorkspaces.mid(0, MAX_RECENT);

    saveRecent();
    emit recentWorkspacesChanged();
}

void WorkspaceManager::removeFromRecent(const QString &path)
{
    m_recentWorkspaces.removeAll(path);
    saveRecent();
    emit recentWorkspacesChanged();
}

void WorkspaceManager::clearRecent()
{
    m_recentWorkspaces.clear();
    saveRecent();
    emit recentWorkspacesChanged();
}

QString WorkspaceManager::workspaceName(const QString &path) const
{
    return QFileInfo(path).fileName();
}

void WorkspaceManager::loadRecent()
{
    m_recentWorkspaces = m_settings.value("recentWorkspaces").toStringList();
    QStringList valid;
    for (const QString &p : m_recentWorkspaces) {
        if (QDir(p).exists())
            valid.append(p);
    }
    m_recentWorkspaces = valid;
}

void WorkspaceManager::saveRecent()
{
    m_settings.setValue("recentWorkspaces", m_recentWorkspaces);
    m_settings.sync();
}
