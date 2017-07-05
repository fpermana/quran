#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>

class DbManager : public QObject
{
    Q_OBJECT
public:
    explicit DbManager(QObject *parent = 0);
    ~DbManager();

    void init(const QString value);
    bool openDB();
    void closeDB();
    bool checkForUpdate();
    QSqlError lastError();

    QSqlDatabase *getDb() const;

    int getPages();

private:
    QSqlDatabase *db;
    QString filepath;
};

#endif // DBMANAGER_H
