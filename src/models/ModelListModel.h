#ifndef MODELLISTMODEL_H
#define MODELLISTMODEL_H

#include <QAbstractListModel>
#include <QQmlEngine>

class ModelListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        DisplayNameRole
    };

    explicit ModelListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void setModels(const QStringList &models);
    Q_INVOKABLE int indexOf(const QString &model) const;

signals:
    void countChanged();

private:
    QStringList m_models;
};

#endif // MODELLISTMODEL_H
