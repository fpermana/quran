#include "DbManager.h"
#include "GlobalConstants.h"
#include "GlobalFunctions.h"
#include "utils/FileExtractorWorker.h"
#include <QDebug>
#include <QSqlQuery>
#include <QFileInfo>
#include <QDir>
#include <QDateTime>
#include <QSettings>

DbManager::DbManager(QObject *parent) : QObject(parent), db(nullptr)
{
}

DbManager::~DbManager()
{
    if(db) {
        db->close();
        delete db;
    }
}

void DbManager::openDB()
{
    checkDatabase();
    if(db)
        emit dataReady(db->isOpen());
}

void DbManager::closeDB()
{
    db->close();
}

bool DbManager::checkForUpdate()
{
    bool settingsExist = tableExist("settings");
    QVariantMap settingsMap;
    if(settingsExist) {
        QVariantMap dataMap = getDbSettings();
        QStringList keys = dataMap.keys();
        foreach (QString key, keys) {
            settingsMap.insert(key, dataMap.value(key).toString());
        }
    }
    else {
        QSqlQuery query(*db);
        QString queryString = QString("CREATE TABLE settings (`key` TEXT PRIMARY KEY, `value` TEXT);");
        if(!query.exec(queryString)) {
            qDebug() << query.lastError().text();
        }

        query.clear();
    }

    int dbVersion = settingsMap.value(DB_VERSION_KEY, FIRST_RELEASE_DB_VERSION).toInt();

    if(dbVersion < 3) {
        db->close();
        delete db;
        QSqlDatabase::removeDatabase(DEFAULT_CONNECTION_NAME);
        db = new QSqlDatabase(QSqlDatabase::database(DEFAULT_CONNECTION_NAME));

        QFileInfo fileInfo(QString("%1").arg(filepath));
        QFile f(fileInfo.absoluteFilePath());
#ifdef Q_OS_WIN
        f.setPermissions(QFile::ReadOther|QFile::WriteOther);
#endif
        if(f.remove(fileInfo.absoluteFilePath()))
            qDebug() << fileInfo.absoluteFilePath() << "Removed";

        QSettings newSettings(QSettings::IniFormat, QSettings::UserScope, QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION));
        fileInfo.setFile(newSettings.fileName());
        qDebug() << fileInfo.path() << fileInfo.filePath();
        bool exist = QFile::exists(fileInfo.path()+"/Quran.conf");
        if(exist) {
            QFile::remove(fileInfo.path()+"/sailquran.ini");
            QFile::rename(fileInfo.path()+"/Quran.conf",fileInfo.path()+"/sailquran.ini");
        }

        checkDatabase();
    }
    else {
        int currentDbVersion = QString(CURRENT_DB_VERSION).toInt();
        for(int i=(dbVersion+1); i<=currentDbVersion; i++) {

        }
    }
    return true;
}

QSqlError DbManager::lastError()
{
    return db->lastError();
}

void DbManager::dbExtracted(const bool isOk)
{
    if(isOk) {
        QFileInfo fileInfo(QString("%1.zip").arg(filepath));
        QFile f(fileInfo.absoluteFilePath());
#ifdef Q_OS_WIN
        f.setPermissions(QFile::ReadOther|QFile::WriteOther);
#endif
        f.remove(fileInfo.absoluteFilePath());

        prepareDatabase();

        if(db)
            emit dataReady(db->isOpen());
    }
}

void DbManager::checkDatabase()
{
    filepath = GlobalFunctions::databaseLocation();
    QFile file(filepath);

    if(!file.exists()) {
        QFile dbSrc(QString(":/db/%1.zip").arg(DB_NAME));
        QFileInfo fileInfo(QString("%1.zip").arg(filepath));
        QDir dbDir = fileInfo.absoluteDir();
        if(!dbDir.exists())
            dbDir.mkpath(fileInfo.absolutePath());
        if(fileInfo.exists()) {
            QFile f(fileInfo.absoluteFilePath());
#ifdef Q_OS_WIN
            f.setPermissions(QFile::ReadOther|QFile::WriteOther);
#endif
            f.remove(fileInfo.absoluteFilePath());
        }
        if(!dbSrc.copy(fileInfo.absoluteFilePath())) {
            qDebug() << dbSrc.errorString();
        }
        else {
            QVariantMap fileMap;
            fileMap.insert(SOURCE_FILEPATH_KEY, fileInfo.absoluteFilePath());

            QVariantList fileList;
            fileList.append(fileMap);
            FileExtractorWorker *f = new FileExtractorWorker(this);
            f->setFileZipList(fileList);
            connect(f, SIGNAL(finished(bool)), this, SLOT(dbExtracted(bool)));
            connect(f, SIGNAL(finished()), f, SLOT(deleteLater()));
            f->start();
        }
    }
    else {
        prepareDatabase();
    }
}

void DbManager::prepareDatabase()
{
    QFileInfo fileInfo(filepath);

    qDebug() << __FUNCTION__ << fileInfo.canonicalFilePath() << fileInfo.dir().path();

//    QString dbManagerName = Hash::md5(fileInfo.absoluteFilePath());
    QString dbManagerName = filepath;
    db = new QSqlDatabase(QSqlDatabase::database(DEFAULT_CONNECTION_NAME));

    if (!db->isOpen()) {
        qDebug() << "QE Opening database";
        db = new QSqlDatabase(QSqlDatabase::addDatabase("QSQLITE", DEFAULT_CONNECTION_NAME));
        db->setDatabaseName(filepath);
        qDebug() << "DB Name:" << db->databaseName();
        if (db->open()) {
            checkForUpdate();
        }
        else {
            qWarning() << "QE failed to open database";
        }
    }
    else {
        qWarning() << "QE used existing DB connection!";
    }
}

bool DbManager::tableExist(const QString tableName)
{
    bool result = false;
    QSqlQuery query(*db);
    QString queryString = QString("SELECT name FROM sqlite_master WHERE type='table' AND name='%1';").arg(tableName);
    query.exec(queryString);
    while (query.next())
    {
        QString name = query.value("name").toString();
        if (name == tableName) {
            result = true;
            break;
        }
    }

    query.clear();
    return result;
}

QVariantMap DbManager::getDbSettings()
{
    QVariantMap dataMap;
    QSqlQuery query(*db);
    query.prepare("SELECT * FROM settings");

    if (!query.exec()) {
        qDebug() << "Query error:" + query.lastError().text();
    }
    else if (!query.first()) {
        qDebug() << "No data in the database";
    }
    else {
        do {
            dataMap.insert(query.value("key").toString(),query.value("value").toString());
        } while(query.next());
    }

    query.clear();
    return dataMap;
}
