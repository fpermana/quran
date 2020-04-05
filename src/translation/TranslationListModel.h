#ifndef TRANSLATIONLISTMODEL_H
#define TRANSLATIONLISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include "TranslationModel.h"

class TranslationListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    TranslationListModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    void setTranslationList(const QList<TranslationModel *> &value);

public slots:
    TranslationModel* get(const int index) const;
    int count() const;

private:
    QList<TranslationModel*> m_translationList;
    QHash<int, QByteArray> m_roles;

    enum DataRoles {
        number = Qt::UserRole + 1,
        flag,
        lang,
        name,
        translator,
        tid,
        installed,
        is_default,
        visible,
        iso6391
    };
};

#if QT_VERSION < 0x050000
Q_DECLARE_METATYPE(TranslationListModel*)
#endif

#endif // TRANSLATIONLISTMODEL_H
