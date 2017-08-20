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
    bool settingsExist = checkTable("settings");
    QVariantMap settingsMap;
    if(settingsExist) {
        QVariantMap dataMap = getDbSettings();
        QStringList keys = dataMap.keys();
        foreach (QString key, keys) {
            settingsMap.insert(key, dataMap.value(key).toString());
        }
    }
    else {
        QSqlQuery *query = new QSqlQuery(*db);
        QString queryString = QString("CREATE TABLE settings (`key` TEXT PRIMARY KEY, `value` TEXT);");
        if(!query->exec(queryString)) {
            qDebug() << query->lastError().text();
        }

        query->clear();
        delete query;
    }

    int dbVersion = settingsMap.value(DB_VERSION_KEY, FIRST_RELEASE_DB_VERSION).toInt();
    int currentDbVersion = QString(CURRENT_DB_VERSION).toInt();

    for(int i=(dbVersion+1); i<=currentDbVersion; i++) {
//        qDebug() << i;
        if(i==1) {
            QStringList defaultTranslationList;
            defaultTranslationList << "en_sahih" << "id_indonesian";

            foreach (QString tableName, defaultTranslationList) {
                if(checkTable(tableName)) {
                    QSqlQuery *query = new QSqlQuery(*db);
                    QString queryString = QString("ALTER TABLE %1 RENAME TO tmp_table_name").arg(tableName);
                    if(query->exec(queryString)) {
                        queryString = QString("CREATE TABLE IF NOT EXISTS %1 (`id` int(4) NOT NULL PRIMARY KEY, `sura` int(3) NOT NULL default '0', `aya` int(3) NOT NULL default '0', `text` text NOT NULL, UNIQUE (sura, aya));").arg(tableName);
                        if(query->exec(queryString)) {
                            queryString = QString("INSERT INTO %1 (`id`, `sura`, `aya`, `text`) SELECT `id`, `sura`, `aya`, `text` FROM tmp_table_name;").arg(tableName);
                            if(query->exec(queryString)) {
                                queryString = QString("DROP TABLE tmp_table_name");
                                if(query->exec(queryString)) {
                                    qDebug() << tableName << "DONE";
                                }
                            }
                        }
                    }
                    /*QString queryString = QString("CREATE UNIQUE INDEX idx_%1 ON %1(sura,aya)").arg(tableName);
                    if(!query->exec(queryString)) {
                        qDebug() << query->lastError().text();
                    }*/

                    query->clear();
                    delete query;
                }
            }

            if(!checkTable("translations")) {
                QSqlQuery *query = new QSqlQuery(*db);
                QString queryString = QString("CREATE TABLE translations (id INTEGER NOT NULL PRIMARY KEY, flag text NOT NULL, lang text NOT NULL, name text NOT NULL, translator text NOT NULL, tid text NOT NULL, installed INTEGER, is_default INTEGER, visible INTEGER, iso6391 text);");
                if(!query->exec(queryString)) {
                    qDebug() << query->lastError().text();
                }

                query->clear();
                delete query;
            }
            else {
                QStringList newColumnList;
                newColumnList << "is_default" << "visible" << "iso6391";

                foreach (QString column, newColumnList) {
                    QSqlQuery *query = new QSqlQuery(*db);
                    QString type = "INTEGER";
                    if(column == "iso6391")
                        type = "text";
                    QString queryString = QString("ALTER TABLE translations ADD COLUMN %1 %2").arg(column).arg(type);
                    if(!query->exec(queryString)) {
                        qDebug() << query->lastError().text();
                    }

                    query->clear();
                    delete query;
                }
            }

            QStringList iso6391List;
            iso6391List << "am" << "ar" << "az" << "ber" << "bg" << "bn" << "bs" << "cs" << "de" << "dv" << "en" << "es" << "fa" << "ha" << "hi" << "id" << "it" << "ja" << "ko" << "ku" << "ml" << "ms" << "nl" << "no" << "pl" << "ps" << "pt" << "ro" << "ru" << "sd" << "so" << "sq" << "sv" << "sw" << "ta" << "tg" << "th" << "tr" << "tt" << "ug" << "ur" << "uz" << "zh";

            foreach (QString iso, iso6391List) {
                QSqlQuery *query = new QSqlQuery(*db);
                QString queryString = QString("UPDATE translations SET iso6391='%1' WHERE tid LIKE '%1.%2'").arg(iso).arg("%");

                if(!query->exec(queryString)) {
                    qDebug() << iso << query->lastError().text();
                }
                else {
                    qDebug() << iso << query->numRowsAffected();
                }

                query->clear();
                delete query;
            }

            for(int j=0; j<3; j++) {
                QSqlQuery *query = new QSqlQuery(*db);
                if(j==0) {
                    query->prepare("UPDATE translations SET visible=:first, is_default =:second WHERE 1");
                    query->bindValue(":first",1);
                    query->bindValue(":second",0);
                }
                else if(j==1) {
                    query->prepare("UPDATE translations SET is_default=:first WHERE tid LIKE ':second' OR  tid LIKE ':third'");
                    query->bindValue(":first",1);
                    query->bindValue(":second","en.sahih");
                    query->bindValue(":third","id.indonesian");
                }
                else {
                    query->prepare("INSERT OR REPLACE INTO settings (`key`, `value`) values (:first, :second);");
                    query->bindValue(":first",DB_VERSION_KEY);
                    query->bindValue(":second",i);
                }

                if(!query->exec()) {
                    qDebug() << j << query->lastError().text();
                }

                query->clear();
                delete query;
            }
        }
    }
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

int DbManager::openSura(const int sura)
{
    int page;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT id, aya, sura FROM pages WHERE sura <= :first ORDER BY sura DESC LIMIT 1;");
    query->bindValue(":first",sura);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        int aya = query->value("aya").toInt();
        int msura = query->value("sura").toInt();
        page = query->value("id").toInt();
        if(aya != 1 && msura == sura)
            page--;
    }

    return page;
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

double DbManager::getYPosition(const int page)
{
    double y = -1.0;

    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT y FROM contentY WHERE page = :first LIMIT 1");
    query->bindValue(":first",page);

    if (!query->exec()) {
        qDebug() << __FUNCTION__ << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        y = query->value("y").toDouble();
    }

    return y;
}

int DbManager::setYPosition(const int page, const double position)
{
    int rows = 0;

    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("UPDATE contentY SET y=:first WHERE page = :second");
    query->bindValue(":first",position);
    query->bindValue(":second",page);

    if (!query->exec()) {
        qDebug() << __FUNCTION__ << "Query error:" + query->lastError().text();
    }
    else {
        rows = query->numRowsAffected();
    }

    return rows;
}

bool DbManager::installTranslation(const QString &tid)
{
    bool result = 0;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("UPDATE translations SET installed=1 WHERE tid = :first");
    query->bindValue(":first",tid);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else {
        qDebug() << query->numRowsAffected();
        result = true;
    }

    query->clear();
    delete query;

    return result;
}

bool DbManager::uninstallTranslation(const QString &tid)
{
    bool result = 0;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("UPDATE translations SET installed=0 WHERE tid LIKE ':first'");
    query->bindValue(":first",tid);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else {
        qDebug() << query->numRowsAffected();
        result = true;
    }

    query->clear();
    delete query;

    return result;
}

bool DbManager::checkTable(const QString &tableName)
{
    bool result = false;
    QSqlQuery *query = new QSqlQuery(*db);
    QString queryString = QString("SELECT name FROM sqlite_master WHERE type='table' AND name='%1';").arg(tableName);
    query->exec(queryString);
    while (query->next())
    {
        QString name = query->value("name").toString();
        if (name == tableName) {
            result = true;
            break;
        }
    }

    query->clear();
    delete query;

    return result;
}

QVariantMap DbManager::getDbSettings()
{
    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("SELECT * FROM settings");

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
        do {
            dataMap.insert(query->value("key").toString(),query->value("value").toString());
        } while(query->next());
    }

    query->clear();
    delete query;
    return dataMap;
}

QVariantMap DbManager::getJuz(const int sura, const int aya, const QString &textType)
{
    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
//    query->prepare("SELECT MAX(juzs.id), juz_names.name, juz_names.tname FROM juzs JOIN quran_text ON juzs.aya = quran_text.aya and juzs.sura = quran_text.sura JOIN juz_names ON juzs.id = juz_names.id WHERE quran_text.id <= (SELECT id FROM quran_text WHERE sura = :first AND aya = :second)");
//    query->prepare("SELECT juzs.id, juz_names.name, juz_names.tname FROM juzs JOIN quran_text ON juzs.aya = quran_text.aya and juzs.sura = quran_text.sura JOIN juz_names ON juzs.id = juz_names.id WHERE quran_text.id <= (SELECT id FROM quran_text WHERE sura = :first AND aya = :second) ORDER BY juzs.id DESC LIMIT 1");
    query->prepare(QString("SELECT juz_names.id, juz_names.name, juz_names.tname FROM (SELECT juzs.id FROM juzs JOIN %1 ON juzs.aya = %1.aya and juzs.sura = %1.sura WHERE %1.id <= (SELECT id FROM %1 WHERE sura = :first AND aya = :second) ORDER BY juzs.id DESC LIMIT 1) AS j JOIN juz_names ON j.id = juz_names.id").arg(textType));
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

QVariantMap DbManager::getQuranText(const int sura, const int aya, const QString &textType)
{
    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare(QString("SELECT * FROM %1 WHERE sura = :first AND aya = :second").arg(textType));
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

void DbManager::addBookmark(const int quranTextId)
{
//    QVariantMap dataMap;
    QSqlQuery *query = new QSqlQuery(*db);
    query->prepare("UPDATE bookmarks SET mark = (~(mark&1))&(mark|1) WHERE id = :first");
    query->bindValue(":first",quranTextId);

    if (!query->exec()) {
        qDebug() << "Query error:" + query->lastError().text();
    }
    else if (!query->first()) {
        qDebug() << "No data in the database";
    }
    else {
//        dataMap.insert(key, query->value(key));
    }

    query->clear();
    delete query;
//    return dataMap;
}
