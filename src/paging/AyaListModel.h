#ifndef AYALISTMODEL_H
#define AYALISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include "AyaModel.h"

class AyaListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    AyaListModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    void setAyaList(const QList<AyaModel *> &value);

public slots:
    void addAyaList(const QList<AyaModel *> &value);
    void removeAya(const int number);
    void addAya(AyaModel *value);
    AyaModel* get(const int index) const;
    void remove(const int index);

private:
    QList<AyaModel*> m_ayaList;
    QHash<int, QByteArray> m_roles;

    enum DataRoles {
        number = Qt::UserRole + 1,
        text,
        translation,
        sura,
        aya,
        suraName,
        marked
    };
};

#if QT_VERSION < 0x050000
Q_DECLARE_METATYPE(AyaListModel*)
#endif

#endif // AYALISTMODEL_H
