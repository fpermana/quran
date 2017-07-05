#include "DbManager.h"
#include <QDebug>
#include <QSqlQuery>
#include <QFileInfo>
#include <QDir>

DbManager::DbManager(QObject *parent)
{

}

DbManager::~DbManager()
{
    db->close();
    delete db;
}

void DbManager::init(const QString value)
{
    filepath = value;
    openDB();
}

bool DbManager::openDB()
{
    QFileInfo fileInfo(filepath);

    qDebug() << __FUNCTION__ << fileInfo.canonicalFilePath() << fileInfo.dir().path();

//    QString dbManagerName = Hash::md5(fileInfo.absoluteFilePath());
    QString dbManagerName = filepath;
    db = new QSqlDatabase(QSqlDatabase::database(dbManagerName));

    if (!db->isOpen()) {
        qDebug() << "QE Opening database";
        db = new QSqlDatabase(QSqlDatabase::addDatabase("QSQLITE", dbManagerName));
        db->setDatabaseName(filepath);
        qDebug() << "DB Name:" << db->databaseName();
        if (db->open()) {
            checkForUpdate();
        }
        else
            qWarning() << "QE failed to open database";
    }
    else {
        qWarning() << "QE used existing DB connection!";
    }

    // Open databasee
    return db->isOpen();
}

void DbManager::closeDB()
{
    db->close();
}

bool DbManager::checkForUpdate()
{

}

QSqlError DbManager::lastError()
{
    return db->lastError();
}

QSqlDatabase *DbManager::getDb() const
{
    return db;
}

int DbManager::getPages()
{
    int pages = 1;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT max(id) FROM pages;");

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No Unchecked invoice in the database";
    }
    else {
        qDebug() << query->value(0);
        /*do {
            tmp.append(query.value(0).toString());
        } while(query.next());*/
    }

    query->clear();
    delete query;
    return pages;
}
