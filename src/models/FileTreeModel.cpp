#include "FileTreeModel.h"
#include <QFileInfo>

FileTreeModel::FileTreeModel(QObject *parent)
    : QFileSystemModel(parent)
{
    setFilter(QDir::AllEntries | QDir::NoDotAndDotDot | QDir::AllDirs);
    setNameFilterDisables(false);
}

QHash<int, QByteArray> FileTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles = QFileSystemModel::roleNames();
    roles[FilePathRole] = "filePath";
    roles[IsDirectoryRole] = "isDirectory";
    roles[FileNameRole] = "fileName";
    roles[FileSizeRole] = "fileSize";
    return roles;
}

QVariant FileTreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case FilePathRole:
        return QFileSystemModel::filePath(index);
    case IsDirectoryRole:
        return QFileSystemModel::isDir(index);
    case FileNameRole:
        return QFileSystemModel::fileName(index);
    case FileSizeRole:
        return QFileSystemModel::size(index);
    default:
        return QFileSystemModel::data(index, role);
    }
}

void FileTreeModel::setRootDirectory(const QString &path)
{
    if (m_rootDir != path) {
        m_rootDir = path;
        setRootPath(path);
        emit rootDirectoryChanged();
    }
}

QModelIndex FileTreeModel::rootModelIndex() const
{
    return index(m_rootDir);
}

QString FileTreeModel::filePath(const QModelIndex &index) const
{
    return QFileSystemModel::filePath(index);
}

bool FileTreeModel::isDir(const QModelIndex &index) const
{
    return QFileSystemModel::isDir(index);
}
