#include "TranslationListModel.h"

TranslationListModel::TranslationListModel(QObject *parent) : QAbstractListModel(parent)
{
    m_roles = QAbstractListModel::roleNames();
    m_roles.insert(number, "number");
    m_roles.insert(flag, "flag");
    m_roles.insert(lang, "lang");
    m_roles.insert(name, "name");
    m_roles.insert(translator, "translator");
    m_roles.insert(tid, "tid");
    m_roles.insert(installed, "installed");
    m_roles.insert(is_default, "isDefault");
    m_roles.insert(visible, "visible");
    m_roles.insert(iso6391, "iso6391");

#if QT_VERSION < 0x050000
    setRoleNames(m_roles);
#endif
}

int TranslationListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED( parent )
    return m_translationList.count();
}

QVariant TranslationListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant(); // Return Null variant if index is invalid
    if (index.row() > (m_translationList.count()-1) )
        return QVariant();

    TranslationModel* translationModel = m_translationList.at(index.row());

    switch (role)
    {
    case number:
        return QVariant::fromValue(translationModel->number());
    case flag:
        return QVariant::fromValue(translationModel->flag());
    case lang:
        return QVariant::fromValue(translationModel->lang());
    case name:
        return QVariant::fromValue(translationModel->name());
    case translator:
        return QVariant::fromValue(translationModel->translator());
    case tid:
        return QVariant::fromValue(translationModel->tid());
    case installed:
        return QVariant::fromValue(translationModel->installed());
    case is_default:
        return QVariant::fromValue(translationModel->isDefault());
    case visible:
        return QVariant::fromValue(translationModel->visible());
    case iso6391:
        return QVariant::fromValue(translationModel->iso6391());
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> TranslationListModel::roleNames() const
{
    return m_roles;
}

void TranslationListModel::setTranslationList(const QList<TranslationModel*> &value)
{
    emit beginResetModel();
    m_translationList = value;
    emit endResetModel();
}

TranslationModel *TranslationListModel::get(const int index) const
{
    if(index<0 || index >= m_translationList.length())
        return nullptr;

    return m_translationList.at(index);
}

int TranslationListModel::count() const
{
    return m_translationList.count();
}
