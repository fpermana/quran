#include "QuranManager.h"
#include <QDebug>
#include "GlobalConstants.h"

QuranManager::QuranManager(QObject *parent) : QObject(parent)
{

}

int QuranManager::pageCount() const
{
    int pages = 1;

    return pages;
}

AyaModel *QuranManager::getBismillah(const QString quranText, const QString translation) const
{
    AyaModel *ayaModel = nullptr;

    return ayaModel;
}

AyaModel *QuranManager::getAya(const int sura, const int aya,const QString quranText, const QString translation) const
{
    AyaModel *ayaModel = nullptr;

    return ayaModel;
}

int QuranManager::getSuraPage(const int sura) const
{
    int page = 0;
    return page;
}

int QuranManager::getSuraAyaPage(const int sura, const int aya) const
{
    int page = 0;

    return page;
}

QList<SuraModel *> QuranManager::getSuraList() const
{
    QList<SuraModel *> suraList;

    return suraList;
}
