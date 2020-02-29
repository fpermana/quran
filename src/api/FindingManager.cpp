#include "FindingManager.h"
#include <QDebug>
#include "GlobalConstants.h"

FindingManager::FindingManager(QObject *parent) : QObject(parent)
{

}

QList<AyaModel *> FindingManager::find(const QString keywords, const QString quranText, const QString translation, const int from, const int limit, const int lastId) const
{
    QList<AyaModel *> ayaList;

    return ayaList;
}
