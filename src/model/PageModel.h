#ifndef PAGEMODEL_H
#define PAGEMODEL_H

#include "SqlQueryModel.h"
#include <QSqlDatabase>

class PageModel : public SqlQueryModel
{
    Q_OBJECT
public:
    explicit PageModel(QObject *parent = 0);
    explicit PageModel(QSqlDatabase *db, QObject *parent = 0);
    void getAyas(const int sura1, const int aya1, const int sura2, const int aya2);

    void setPage(int value);
    int getPage() const;

signals:

public slots:

private:
    QSqlDatabase *db;
    int page;
};

#endif // PAGEMODEL_H
