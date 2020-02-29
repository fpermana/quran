#include "AyaListModel.h"

AyaListModel::AyaListModel(QObject *parent) : QAbstractListModel(parent)
{
    m_roles = QAbstractListModel::roleNames();
    m_roles.insert(number, "number");
    m_roles.insert(text, "text");
    m_roles.insert(translation, "translation");
    m_roles.insert(sura, "sura");
    m_roles.insert(aya, "aya");
    m_roles.insert(suraName, "suraName");
    m_roles.insert(marked, "marked");
#if QT_VERSION < 0x050000
    setRoleNames(m_roles);
#endif
}

int AyaListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED( parent )
    return m_ayaList.count();
}

QVariant AyaListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant(); // Return Null variant if index is invalid
    if (index.row() > (m_ayaList.count()-1) )
        return QVariant();

    AyaModel* ayaModel = m_ayaList.at(index.row());

    switch (role)
    {
    case number:
        return QVariant::fromValue(ayaModel->number());
    case text:
        return QVariant::fromValue(ayaModel->text());
    case translation:
        return QVariant::fromValue(ayaModel->translation());
    case sura:
        return QVariant::fromValue(ayaModel->sura());
    case aya:
        return QVariant::fromValue(ayaModel->aya());
    case suraName:
        return QVariant::fromValue(ayaModel->suraName());
    case marked:
        return QVariant::fromValue(ayaModel->marked());
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> AyaListModel::roleNames() const
{
    return m_roles;
}

void AyaListModel::setAyaList(const QList<AyaModel*> &value)
{
    emit beginResetModel();
    m_ayaList = value;
    emit endResetModel();
}

void AyaListModel::addAyaList(const QList<AyaModel *> &value) {

    if(value.empty())
        return;
    emit beginInsertRows(QModelIndex(), m_ayaList.count(), m_ayaList.count()+value.count()-1);
    m_ayaList.append(value);
    emit endInsertRows();
}

void AyaListModel::removeAya(const int number)
{
    int index = -1;
    int c = 0;
    foreach (AyaModel *value, m_ayaList) {
        if(value->number() == number) {
            index = c;
            break;
        }
        c++;
    }

    if(index >= 0) {
        emit beginRemoveRows(QModelIndex(), index,index);
        m_ayaList.removeAt(index);
        emit endRemoveRows();
    }
}

void AyaListModel::addAya(AyaModel *value)
{
    emit beginInsertRows(QModelIndex(), m_ayaList.count(), m_ayaList.count());
    m_ayaList.append(value);
    emit endInsertRows();
}

AyaModel *AyaListModel::get(const int index) const
{
    if(index<0 || index >= m_ayaList.length())
        return nullptr;

    return m_ayaList.at(index);
}
