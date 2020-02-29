#ifndef SURALISTMODEL_H
#define SURALISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include "SuraModel.h"

class SuraListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    SuraListModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    void setSuraList(const QList<SuraModel *> &value);
private:
    QList<SuraModel*> m_suraList;
    QHash<int, QByteArray> m_roles;

    enum DataRoles {
        number = Qt::UserRole + 1,
        ayas,
        start,
        name,
        tname,
        ename,
        type,
        order,
        rukus
    };
};

#if QT_VERSION < 0x050000
Q_DECLARE_METATYPE(SuraListModel*)
#endif

#endif // SURALISTMODEL_H
