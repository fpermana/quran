#ifndef PAGEMODEL_H
#define PAGEMODEL_H

#include "SqlQueryModel.h"
#include <QSqlDatabase>

class PageModel : public SqlQueryModel
{
    Q_OBJECT
public:
    explicit PageModel(QSqlDatabase *db, QObject *parent = 0);

    void getPage(const int page);

signals:

public slots:

private:
    QSqlDatabase *db;
};

#endif // PAGEMODEL_H
