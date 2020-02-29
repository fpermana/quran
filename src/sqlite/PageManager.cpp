#include "PageManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

#include "GlobalConstants.h"

PageManager::PageManager(QString quranText, QString translation, QObject *parent) :
    QObject(parent), m_quranText(quranText), m_translation(translation)
{

}

QString PageManager::getQuranText() const
{
    return m_quranText;
}

void PageManager::setQuranText(const QString &value)
{
    m_quranText = value;
}

QString PageManager::getTranslation() const
{
    return m_translation;
}

void PageManager::setTranslation(const QString &translation)
{
    m_translation = translation;
}

QPair<int, int> PageManager::getSuraAyaStart(const int pageNumber) const
{
    QPair<int, int> suraAya;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QSqlQuery query(db);
        query.prepare("SELECT sura,aya FROM pages WHERE id = :id");
        query.bindValue(":id",pageNumber);

        if (!query.exec()) {
            qDebug() << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            suraAya.first = query.value(0).toInt();
            suraAya.second = query.value(1).toInt();
        }
        query.clear();
    }
    return suraAya;
}

int PageManager::getIdBySuraAya(const int suraNumber, const int ayaNumber) const
{
    int id = 0;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT * FROM %1 WHERE sura = :sura AND aya = :aya").arg(m_quranText);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":sura",suraNumber);
        query.bindValue(":aya",ayaNumber);

        if (!query.exec()) {
            qDebug() << "Query error:" + query.lastError().text();
        }
        else if (!query.first()) {
            qDebug() << "No data in the database";
        }
        else {
            id = query.value(0).toInt();
        }
        query.clear();
    }
    return id;
}

AyaModel *PageManager::getAya(const int id)
{
    AyaModel *ayaModel = nullptr;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura WHERE id = :id").arg(m_quranText).arg(m_translation);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id",id);

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

QList<AyaModel *> PageManager::getAyaListFrom(const int id)
{
    QList<AyaModel *> ayaList;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura WHERE %1.id >= :id").arg(m_quranText).arg(m_translation);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":id",id);

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

QList<AyaModel *> PageManager::getAyaListBetween(const int firstId, const int secondId, const bool inclusive)
{
    QList<AyaModel *> ayaList;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name  FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura WHERE %1.id >= :firstId AND %1.id %3 :secondId").arg(m_quranText).arg(m_translation).arg(inclusive?"<=":"<");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":firstId",firstId);
        query.bindValue(":secondId",secondId);

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
