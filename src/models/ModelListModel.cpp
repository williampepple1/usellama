#include "ModelListModel.h"

ModelListModel::ModelListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ModelListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_models.size();
}

QVariant ModelListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_models.size())
        return QVariant();

    const QString &model = m_models[index.row()];
    switch (role) {
    case NameRole: return model;
    case DisplayNameRole: {
        QString display = model;
        if (display.contains(':'))
            display = display.left(display.indexOf(':'));
        return display;
    }
    default: return QVariant();
    }
}

QHash<int, QByteArray> ModelListModel::roleNames() const
{
    return {
        {NameRole, "name"},
        {DisplayNameRole, "displayName"}
    };
}

void ModelListModel::setModels(const QStringList &models)
{
    beginResetModel();
    m_models = models;
    endResetModel();
    emit countChanged();
}

int ModelListModel::indexOf(const QString &model) const
{
    return m_models.indexOf(model);
}
