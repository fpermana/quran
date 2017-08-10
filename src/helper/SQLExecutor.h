#ifndef GLOBALFUNCTIONS_H
#define GLOBALFUNCTIONS_H

#include <QObject>
#include <QFile>
#include <QSqlDatabase>

class SQLExecutor
{
public:
    static void executeQueryFile(QFile &qf, QSqlDatabase &db);
};

#endif // GLOBALFUNCTIONS_H
