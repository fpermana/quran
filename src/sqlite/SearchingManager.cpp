#include "SearchingManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include "GlobalConstants.h"

SearchingManager::SearchingManager(QObject *parent) : QObject(parent)
{

}

QList<AyaModel *> SearchingManager::search(const QString keywords, const QString quranText, const QString translation, const int from, const int limit, const int lastId) const
{
    QList<AyaModel *> ayaList;
    QSqlDatabase db = QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT %1.id, %1.text, %2.text, %1.sura, %1.aya, suras.name FROM %1 JOIN %2 ON %1.id = %2.id JOIN suras ON suras.id = %1.sura WHERE %2.text LIKE :keywords %3").arg(quranText).arg(translation).arg(lastId > 0 ? QString(" AND %1.id > :lastId ORDER BY %1.id LIMIT %2").arg(quranText).arg(limit) : QString(" ORDER BY %1.id LIMIT %2,%3").arg(quranText).arg(from).arg(limit));
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":keywords",QString("%%1%").arg(keywords));
        if(lastId >= 0)
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
