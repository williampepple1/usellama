#ifndef FILESYSTEMMANAGER_H
#define FILESYSTEMMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QFileSystemWatcher>

class FileSystemManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString rootPath READ rootPath NOTIFY rootPathChanged)

public:
    explicit FileSystemManager(QObject *parent = nullptr);

    QString rootPath() const { return m_rootPath; }
    Q_INVOKABLE void setRootPath(const QString &path);

    Q_INVOKABLE QString readFile(const QString &path) const;
    Q_INVOKABLE bool writeFile(const QString &path, const QString &content) const;
    Q_INVOKABLE bool deleteFile(const QString &path) const;
    Q_INVOKABLE bool createDirectory(const QString &path) const;
    Q_INVOKABLE QStringList listDirectory(const QString &path) const;
    Q_INVOKABLE bool editFile(const QString &path, const QString &oldText, const QString &newText) const;
    Q_INVOKABLE QVariantList searchFiles(const QString &directory, const QString &pattern) const;
    Q_INVOKABLE bool fileExists(const QString &path) const;
    Q_INVOKABLE QString fileName(const QString &path) const;
    Q_INVOKABLE bool isDirectory(const QString &path) const;

signals:
    void rootPathChanged();
    void fileChanged(const QString &path);
    void directoryChanged(const QString &path);

private:
    QString m_rootPath;
    QFileSystemWatcher *m_watcher;
};

#endif // FILESYSTEMMANAGER_H
