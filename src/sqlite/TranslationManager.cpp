#include "TranslationManager.h"
#include <QDebug>
#include <QFile>

#include "GlobalConstants.h"
#include "GlobalFunctions.h"

TranslationManager::TranslationManager(bool threaded, QObject *parent) : QObject(parent), m_threaded(threaded)
{

}

TranslationManager::~TranslationManager()
{
    if(m_threaded) {
        QSqlDatabase::removeDatabase(THREAD_CONNECTION_NAME);
    }
}

QList<TranslationModel *> TranslationManager::getAllTranslation()
{
    QList<TranslationModel *> translationList;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT id, flag, lang, name, translator, tid, installed, is_default, visible, iso6391 FROM translations");
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
                TranslationModel *translationModel = new TranslationModel;
                translationModel->setNumber(query.value(0).toInt());
                translationModel->setFlag(query.value(1).toString());
                translationModel->setLang(query.value(2).toString());
                translationModel->setName(query.value(3).toString());
                translationModel->setTranslator(query.value(4).toString());
                translationModel->setTid(query.value(5).toString());
                translationModel->setInstalled(query.value(6).toBool());
                translationModel->setIsDefault(query.value(7).toBool());
                translationModel->setVisible(query.value(8).toBool());
                translationModel->setIso6391(query.value(9).toString());
                translationList.append(translationModel);
            } while(query.next());
        }
        query.clear();
    }

    return translationList;
}

QList<TranslationModel *> TranslationManager::getInstalledTranslation()
{
    QList<TranslationModel *> translationList;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("SELECT id, flag, lang, name, translator, tid, installed, is_default, visible, iso6391 FROM translations WHERE installed = 1");
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
                TranslationModel *translationModel = new TranslationModel;
                translationModel->setNumber(query.value(0).toInt());
                translationModel->setFlag(query.value(1).toString());
                translationModel->setLang(query.value(2).toString());
                translationModel->setName(query.value(3).toString());
                translationModel->setTranslator(query.value(4).toString());
                translationModel->setTid(query.value(5).toString());
                translationModel->setInstalled(query.value(6).toBool());
                translationModel->setIsDefault(query.value(7).toBool());
                translationModel->setVisible(query.value(8).toBool());
                translationModel->setIso6391(query.value(9).toString());
                translationList.append(translationModel);
            } while(query.next());
        }
        query.clear();
    }

    return translationList;
}

bool TranslationManager::tableExist(const QString tableName)
{
    bool exist = false;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    QSqlQuery query(db);
    QString queryString = QString("SELECT name FROM sqlite_master WHERE type='table' AND name='%1';").arg(tableName);
    query.exec(queryString);
    while (query.next())
    {
        QString name = query.value("name").toString();
        if (name == tableName) {
            exist = true;
            break;
        }
    }

    query.clear();
    return exist;
}

int TranslationManager::rowCount(const QString tableName)
{
    bool rowCount = 0;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    QSqlQuery query(db);
    QString queryString = QString("SELECT COUNT(id) FROM %1;").arg(tableName);
    query.exec(queryString);
    while (query.next())
    {
        rowCount = query.value(0).toInt();
        break;
    }

    query.clear();
    return rowCount;
}

bool TranslationManager::installTranslation(const QString &tid)
{
    bool success = false;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE translations SET installed = 1 WHERE tid = '%1'").arg(tid);
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
//        query.bindValue(":tid", tid);

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

bool TranslationManager::uninstallTranslation(const QString &tid)
{
    bool success = false;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QString queryString = QString("UPDATE translations SET installed = 0 WHERE tid = :tid");
//        qDebug() << queryString;
        QSqlQuery query(db);
        query.prepare(queryString);
        query.bindValue(":tid", tid);

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

bool TranslationManager::createTranslationTable(const QString &tableName)
{
    bool success = false;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        QSqlQuery query(db);
        QString createTableString = QString("CREATE TABLE IF NOT EXISTS %1 (`id` int(4) NOT NULL PRIMARY KEY, `sura` int(3) NOT NULL default '0', `aya` int(3) NOT NULL default '0', `text` text NOT NULL, UNIQUE (sura, aya));").arg(tableName);
        success = query.exec(createTableString);

        query.clear();
    }

    return success;
}

bool TranslationManager::insertTranslationList(const QString &tableName, QStringList idList, QStringList suraList, QStringList ayaList, QStringList textList)
{
    if(idList.count() != suraList.count() || suraList.count() != ayaList.count() || ayaList.count() != textList.count())
        return false;

    bool success = false;
    QSqlDatabase db = m_threaded ? createDb() : QSqlDatabase::database(DEFAULT_CONNECTION_NAME);
    if(db.isOpen()) {
        db.transaction();
        QSqlQuery query(db);
        QString queryString = QString("INSERT OR IGNORE INTO %1 (id, sura, aya, text) values (?, ?, ?, ?)").arg(tableName);
        query.prepare(queryString);
        query.addBindValue(idList);
        query.addBindValue(suraList);
        query.addBindValue(ayaList);
        query.addBindValue(textList);

        if (!query.execBatch()) {
            qDebug() << query.lastError().text();
        }
        db.commit();
        query.clear();
    }

    return success;
}

QSqlDatabase TranslationManager::createDb()
{
    QString filepath = GlobalFunctions::databaseLocation();
//    QFile file(filepath);
    QSqlDatabase db = QSqlDatabase::database(THREAD_CONNECTION_NAME);
    if(!db.isOpen()) {
        db = QSqlDatabase::addDatabase("QSQLITE", THREAD_CONNECTION_NAME);
        db.setDatabaseName(filepath);
        db.open();
    }

    return db;
}
