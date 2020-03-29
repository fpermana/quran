#include "SearchingManager.h"
#include <QDebug>
#include "GlobalConstants.h"

SearchingManager::SearchingManager(QObject *parent) : QObject(parent)
{

}

QList<AyaModel *> SearchingManager::search(const QString keywords, const QString quranText, const QString translation, const int from, const int limit, const int lastId) const
{
    QList<AyaModel *> ayaList;

    return ayaList;
}
