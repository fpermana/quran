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
        qDebug() << "No data in the database";
    }
    else {
        pages = query->value(0).toInt();
        /*do {
            tmp.append(query.value(0).toString());
        } while(query.next());*/
    }

    query->clear();
    delete query;
    return pages;
}

QStringList DbManager::getPage(const int page)
{
    QStringList dataList;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT * from pages WHERE id = :first OR id = :second");
    query->bindValue(":first",page);
    query->bindValue(":second",page+1);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        do {
            dataList.append(query->value("sura").toString());
            dataList.append(query->value("aya").toString());
        } while(query->next());
    }

    query->clear();
    delete query;
    return dataList;
}

QVariantMap DbManager::getJuz(const int sura, const int aya)
{
    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
//    query->prepare("SELECT MAX(juzs.id), juz_names.name, juz_names.tname FROM juzs JOIN quran_text ON juzs.aya = quran_text.aya and juzs.sura = quran_text.sura JOIN juz_names ON juzs.id = juz_names.id WHERE quran_text.id <= (SELECT id FROM quran_text WHERE sura = :first AND aya = :second)");
//    query->prepare("SELECT juzs.id, juz_names.name, juz_names.tname FROM juzs JOIN quran_text ON juzs.aya = quran_text.aya and juzs.sura = quran_text.sura JOIN juz_names ON juzs.id = juz_names.id WHERE quran_text.id <= (SELECT id FROM quran_text WHERE sura = :first AND aya = :second) ORDER BY juzs.id DESC LIMIT 1");
    query->prepare("SELECT juz_names.id, juz_names.name, juz_names.tname FROM (SELECT juzs.id FROM juzs JOIN quran_text ON juzs.aya = quran_text.aya and juzs.sura = quran_text.sura WHERE quran_text.id <= (SELECT id FROM quran_text WHERE sura = :first AND aya = :second) ORDER BY juzs.id DESC LIMIT 1) AS j JOIN juz_names ON j.id = juz_names.id");
    query->bindValue(":first",sura);
    query->bindValue(":second",aya);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        QStringList keys;
        keys << "id" << "name" << "tname";
        foreach (QString key, keys) {
            dataMap.insert(key, query->value(key));
        }
    }

    query->clear();
    delete query;
    return dataMap;
}

QVariantMap DbManager::getSura(const int sura)
{
    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT * FROM suras WHERE id = :first");
    query->bindValue(":first",sura);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        QStringList keys;
        keys << "id" << "ayas" << "start" << "name" << "tname" << "ename" << "type" << "order" << "rukus";
        foreach (QString key, keys) {
            dataMap.insert(key, query->value(key));
        }
    }

    query->clear();
    delete query;
    return dataMap;
}

QVariantMap DbManager::getQuranText(const int sura, const int aya)
{
    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT * FROM quran_text WHERE sura = :first AND aya = :second");
    query->bindValue(":first",sura);
    query->bindValue(":second",aya);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        QStringList keys;
        keys << "id" << "sura" << "aya" << "text";
        foreach (QString key, keys) {
            dataMap.insert(key, query->value(key));
        }
    }

    query->clear();
    delete query;
    return dataMap;
}
