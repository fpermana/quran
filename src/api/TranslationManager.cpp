#include "TranslationManager.h"
#include <QDebug>

#include "GlobalConstants.h"
#include "GlobalFunctions.h"

TranslationManager::TranslationManager(bool threaded, QObject *parent) : QObject(parent), m_threaded(threaded)
{

}

TranslationManager::~TranslationManager()
{
}

QList<TranslationModel *> TranslationManager::getAllTranslation()
{
    QList<TranslationModel *> translationList;

    return translationList;
}

QList<TranslationModel *> TranslationManager::getInstalledTranslation()
{
    QList<TranslationModel *> translationList;

    return translationList;
}

bool TranslationManager::tableExist(const QString tableName)
{
    bool exist = false;

    return exist;
}

int TranslationManager::rowCount(const QString tableName)
{
    bool rowCount = 0;

    return rowCount;
}

bool TranslationManager::installTranslation(const QString &tid)
{
    bool success = false;

    return success;
}

bool TranslationManager::uninstallTranslation(const QString &tid)
{
    bool success = false;

    return success;
}

bool TranslationManager::createTranslationTable(const QString &tableName)
{
    bool success = false;

    return success;
}

bool TranslationManager::insertTranslationList(const QString &tableName, QStringList idList, QStringList suraList, QStringList ayaList, QStringList textList)
{
    if(idList.count() != suraList.count() || suraList.count() != ayaList.count() || ayaList.count() != textList.count())
        return false;

    bool success = false;

    return success;
}
