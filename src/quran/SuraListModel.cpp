#include "SuraListModel.h"

SuraListModel::SuraListModel(QObject *parent) : QAbstractListModel(parent)
{
    m_roles = QAbstractListModel::roleNames();
    m_roles.insert(number, "number");
    m_roles.insert(ayas, "ayas");
    m_roles.insert(start, "start");
    m_roles.insert(name, "name");
    m_roles.insert(tname, "tname");
    m_roles.insert(ename, "ename");
    m_roles.insert(type, "type");
    m_roles.insert(order, "order");
    m_roles.insert(rukus, "rukus");
#if QT_VERSION < 0x050000
    setRoleNames(m_roles);
#endif
}

int SuraListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED( parent )
    return m_suraList.count();
}

QVariant SuraListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant(); // Return Null variant if index is invalid
    if (index.row() > (m_suraList.count()-1) )
        return QVariant();

    SuraModel* suraModel = m_suraList.at(index.row());

    switch (role)
    {
    case number:
        return QVariant::fromValue(suraModel->number());
    case ayas:
        return QVariant::fromValue(suraModel->ayas());
    case start:
        return QVariant::fromValue(suraModel->start());
    case name:
        return QVariant::fromValue(suraModel->name());
    case tname:
        return QVariant::fromValue(suraModel->tName());
    case ename:
        return QVariant::fromValue(suraModel->eName());
    case order:
        return QVariant::fromValue(suraModel->order());
    case rukus:
        return QVariant::fromValue(suraModel->rukus());
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> SuraListModel::roleNames() const
{
    return m_roles;
}

void SuraListModel::setSuraList(const QList<SuraModel*> &value)
{
    emit beginResetModel();
    m_suraList = value;
    emit endResetModel();
}
