#include "BookmarkManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

#include "GlobalConstants.h"

BookmarkManager::BookmarkManager(QObject *parent) : QObject(parent)
{

}

QList<AyaModel *> BookmarkManager::getBookmarks(const QString quranText, const QString translation, const int lastId, const int limit) const
{
    QList<AyaModel *> ayaList;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura JOIN bookmarks on %1.id = bookmarks.id WHERE bookmarks.marked = 1 AND %1.id > :lastId ORDER BY %1.id LIMIT %3").arg(quranText).arg(translation).arg(limit);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":lastId",lastId);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            do {
                AyaModel *ayaModel = new AyaModel;
                ayaModel->setNumber(query.value(0).toInt());
                ayaModel->setText(query.value(1).toString());
                ayaModel->setTranslation(query.value(2).toString());
                ayaModel->setSura(query.value(3).toInt());
                ayaModel->setAya(query.value(4).toInt());
                ayaModel->setSuraName(query.value(5).toString());
                ayaList.append(ayaModel);
            } while(query.next());
        }
        query.clear();
    }
    return ayaList;
}

QStringList BookmarkManager::getBookmarkIds() const
{
    QStringList idList;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT id FROM bookmarks WHERE marked = :marked");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":marked",1);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            do {
                idList.append(query.value(0).toString());
            } while(query.next());
        }
        query.clear();
    }
    return idList;
}

bool BookmarkManager::checkBookmark(const int number)
{
    bool success = false;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT marked FROM bookmarks WHERE id = :id");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id", number);

        if (!query.exec()) {
            qDebug() << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            success = query.value(0).toBool();
        }
        query.clear();
    }

    return success;
}

bool BookmarkManager::addBookmark(const int number)
{
    bool success = false;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE bookmarks SET marked = 1 WHERE id = :id");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id", number);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else {
            success = true;
        }
        query.clear();
    }

    return success;
}

bool BookmarkManager::removeBookmark(const int number)
{
    bool success = false;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE bookmarks SET marked = 0 WHERE id = :id");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id", number);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else {
            success = true;
        }
        query.clear();
    }

    return success;
}

bool BookmarkManager::clear()
{
    bool success = false;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE bookmarks SET marked = 0 WHERE marked = 1");
        QSqlQuery query(db);
        query.prepare(queryString);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else {
            success = true;
        }
        query.clear();
    }

    return success;
}

bool BookmarkManager::bookmarks(QStringList numberList)
{
    bool success = false;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE bookmarks SET marked = 1 WHERE marked = 0 AND id IN (%1)").arg(numberList.join(","));
        QSqlQuery query(db);
        query.prepare(queryString);
//        query.bindValue(":id", number);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else {
            success = true;
        }
        query.clear();
    }

    return success;
}


bool BookmarkManager::toogleBookmark(const int number)
{
    bool success = false;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE bookmarks SET mark = (~(mark&1))&(mark|1) WHERE id = :id");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id", number);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else {
            success = true;
        }
        query.clear();
    }

    return success;
}
