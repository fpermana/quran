#include "ApiManager.h"
#include "GlobalConstants.h"
#include <QDebug>
#include <QFileInfo>
#include <QDir>
#include <QDateTime>

ApiManager::ApiManager(QObject *parent) : QObject(parent)
{
}

ApiManager::~ApiManager()
{
}

void ApiManager::openDB()
{
    checkDatabase();
}

void ApiManager::closeDB()
{
}

bool ApiManager::checkForUpdate()
{
    bool settingsExist = tableExist("settings");

    return true;
}

void ApiManager::dbExtracted(const bool isOk)
{

}

void ApiManager::checkDatabase()
{

}

void ApiManager::prepareDatabase()
{

}

bool ApiManager::tableExist(const QString tableName)
{
    return true;
}

QVariantMap ApiManager::getDbSettings()
{
    QVariantMap dataMap;

    return dataMap;
}
