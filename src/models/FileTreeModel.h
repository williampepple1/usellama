#ifndef FILETREEMODEL_H
#define FILETREEMODEL_H

#include <QAbstractItemModel>
#include <QFileSystemModel>
#include <QQmlEngine>

class FileTreeModel : public QFileSystemModel
{
    Q_OBJECT

    Q_PROPERTY(QString rootDirectory READ rootDirectory WRITE setRootDirectory NOTIFY rootDirectoryChanged)

public:
    explicit FileTreeModel(QObject *parent = nullptr);

    enum ExtraRoles {
        FilePathRole = Qt::UserRole + 100,
        IsDirectoryRole,
        FileNameRole,
        FileSizeRole
    };

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    QString rootDirectory() const { return m_rootDir; }
    void setRootDirectory(const QString &path);

    Q_INVOKABLE QModelIndex rootModelIndex() const;
    Q_INVOKABLE QString filePath(const QModelIndex &index) const;
    Q_INVOKABLE bool isDir(const QModelIndex &index) const;

signals:
    void rootDirectoryChanged();

private:
    QString m_rootDir;
};

#endif // FILETREEMODEL_H
