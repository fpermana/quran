#include "QuranManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include "GlobalConstants.h"

QuranManager::QuranManager(QObject *parent) : QObject(parent)
{

}

int QuranManager::pageCount() const
{
    int pages = 1;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QSqlQuery query(db);
        query.prepare("SELECT count(id) FROM pages");

        if (!query.exec()) {
            qDebug() << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            pages = query.value(0).toInt();
        }
        query.clear();
    }
    return pages;
}

AyaModel *QuranManager::getBismillah(const QString quranText, const QString translation) const
{
    AyaModel *ayaModel = nullptr;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura WHERE %1.id = :id").arg(quranText).arg(translation);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id",1);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            ayaModel = new AyaModel;
            ayaModel->setNumber(query.value(0).toInt());
            ayaModel->setText(query.value(1).toString());
            ayaModel->setTranslation(query.value(2).toString());
            ayaModel->setSura(query.value(3).toInt());
            ayaModel->setAya(query.value(4).toInt());
            ayaModel->setSuraName(query.value(5).toString());
        }
        query.clear();
    }
    return ayaModel;
}

AyaModel *QuranManager::getAya(const int sura, const int aya,const QString quranText, const QString translation) const
{
    AyaModel *ayaModel = nullptr;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura WHERE %1.sura = :sura AND %1.aya = :aya").arg(quranText).arg(translation);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":sura",sura);
        query.bindValue(":aya",aya);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            ayaModel = new AyaModel;
            ayaModel->setNumber(query.value(0).toInt());
            ayaModel->setText(query.value(1).toString());
            ayaModel->setTranslation(query.value(2).toString());
            ayaModel->setSura(query.value(3).toInt());
            ayaModel->setAya(query.value(4).toInt());
            ayaModel->setSuraName(query.value(5).toString());
        }
        query.clear();
    }
    return ayaModel;
}

QVariantMap QuranManager::getSuraPage(const int sura) const
{
    QVariantMap pageMap;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        int cnt = 0;
        QSqlQuery query(db);
        query.prepare("SELECT COUNT(*) FROM pages WHERE sura = :sura");
        query.bindValue(":sura", sura);
        if (!query.exec()) {
            qDebug() << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            cnt = query.value(0).toInt();
        }

        if(cnt == 0) {
            query.prepare("SELECT id,sura,aya FROM pages WHERE sura <= :sura ORDER BY sura DESC LIMIT 1");
        } else {
            query.prepare("SELECT id,sura,aya FROM pages WHERE sura = :sura ORDER BY sura ASC LIMIT 1");
        }
        query.bindValue(":sura", sura);

        if (!query.exec()) {
            qDebug() << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            pageMap.insert("page",query.value(0));
            pageMap.insert("sura",query.value(1));
            pageMap.insert("aya",query.value(2));
        }
        query.clear();
    }
    return pageMap;
}

QList<SuraModel *> QuranManager::getSuraList() const
{
    QList<SuraModel *> suraList;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT id, ayas, start, name, tname, ename, type, `order`, rukus FROM suras");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);

        if (!query.exec()) {
            qDebug() << __FUNCTION__ << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            do {
                SuraModel *suraModel = new SuraModel;
                suraModel->setNumber(query.value(0).toInt());
                suraModel->setAyas(query.value(1).toInt());
                suraModel->setStart(query.value(2).toInt());
                suraModel->setName(query.value(3).toString());
                suraModel->setTName(query.value(4).toString());
                suraModel->setEName(query.value(5).toString());
                suraModel->setType(query.value(6).toString());
                suraModel->setOrder(query.value(7).toInt());
                suraModel->setRukus(query.value(8).toInt());
                suraList.append(suraModel);
            } while(query.next());
        }
        query.clear();
    }
    return suraList;
}
