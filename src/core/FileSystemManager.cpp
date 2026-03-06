#include "FileSystemManager.h"
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QTextStream>
#include <QRegularExpression>
#include <QDirIterator>

FileSystemManager::FileSystemManager(QObject *parent)
    : QObject(parent)
    , m_watcher(new QFileSystemWatcher(this))
{
    connect(m_watcher, &QFileSystemWatcher::fileChanged, this, &FileSystemManager::fileChanged);
    connect(m_watcher, &QFileSystemWatcher::directoryChanged, this, &FileSystemManager::directoryChanged);
}

void FileSystemManager::setRootPath(const QString &path)
{
    if (m_rootPath != path) {
        m_rootPath = path;
        emit rootPathChanged();
    }
}

QString FileSystemManager::readFile(const QString &path) const
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return QString();
    QTextStream stream(&file);
    return stream.readAll();
}

bool FileSystemManager::writeFile(const QString &path, const QString &content) const
{
    QFileInfo info(path);
    QDir dir = info.dir();
    if (!dir.exists())
        dir.mkpath(".");

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return false;
    QTextStream stream(&file);
    stream << content;
    return true;
}

bool FileSystemManager::deleteFile(const QString &path) const
{
    QFileInfo info(path);
    if (info.isDir()) {
        QDir dir(path);
        return dir.removeRecursively();
    }
    return QFile::remove(path);
}

bool FileSystemManager::createDirectory(const QString &path) const
{
    QDir dir;
    return dir.mkpath(path);
}

QStringList FileSystemManager::listDirectory(const QString &path) const
{
    QDir dir(path);
    if (!dir.exists()) return {};

    QStringList entries;
    for (const QFileInfo &info : dir.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot, QDir::DirsFirst | QDir::Name)) {
        QString prefix = info.isDir() ? "[DIR] " : "";
        entries.append(prefix + info.fileName());
    }
    return entries;
}

bool FileSystemManager::editFile(const QString &path, const QString &oldText, const QString &newText) const
{
    QString content = readFile(path);
    if (content.isNull() || !content.contains(oldText))
        return false;
    content.replace(oldText, newText);
    return writeFile(path, content);
}

QVariantList FileSystemManager::searchFiles(const QString &directory, const QString &pattern) const
{
    QVariantList results;
    QRegularExpression regex(QRegularExpression::escape(pattern));
    QDirIterator it(directory, QDir::Files, QDirIterator::Subdirectories);

    int maxResults = 100;
    int count = 0;

    while (it.hasNext() && count < maxResults) {
        it.next();
        QFile file(it.filePath());
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
            continue;

        QTextStream stream(&file);
        int lineNum = 0;
        while (!stream.atEnd()) {
            lineNum++;
            QString line = stream.readLine();
            QRegularExpressionMatch match = regex.match(line);
            if (match.hasMatch()) {
                QVariantMap result;
                result["file"] = it.filePath();
                result["line"] = lineNum;
                result["content"] = line.trimmed();
                results.append(result);
                count++;
                if (count >= maxResults) break;
            }
        }
    }
    return results;
}

bool FileSystemManager::fileExists(const QString &path) const
{
    return QFileInfo::exists(path);
}

QString FileSystemManager::fileName(const QString &path) const
{
    return QFileInfo(path).fileName();
}

bool FileSystemManager::isDirectory(const QString &path) const
{
    return QFileInfo(path).isDir();
}
