#ifndef PAGEMODEL_H
#define PAGEMODEL_H

#include "SqlQueryModel.h"
#include <QSqlDatabase>
#include <QVariantMap>

class PageModel : public SqlQueryModel
{
    Q_OBJECT
    Q_PROPERTY(QString suraName READ getSuraName CONSTANT)
public:
    explicit PageModel(QObject *parent = 0);
    explicit PageModel(QSqlDatabase *db, QObject *parent = 0);
    void getAyas(const int sura1, const int aya1);
    void getAyas(const int sura1, const int aya1, const int sura2, const int aya2);

    void setPage(int value);
    int getPage() const;

    void setJuz(const QVariantMap &value);
    void setSura(const QVariantMap &value);

    QString getSuraName() const;

signals:

public slots:

private:
    QSqlDatabase *db;
    int page;
    QVariantMap juz;
    QVariantMap sura;
};

#endif // PAGEMODEL_H
