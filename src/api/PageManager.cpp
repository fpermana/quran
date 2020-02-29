#include "PageManager.h"
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

    return suraAya;
}

int PageManager::getIdBySuraAya(const int suraNumber, const int ayaNumber) const
{
    int id = 0;

    return id;
}

AyaModel *PageManager::getAya(const int id)
{
    AyaModel *ayaModel = nullptr;

    return ayaModel;
}

QList<AyaModel *> PageManager::getAyaListFrom(const int id)
{
    QList<AyaModel *> ayaList;

    return ayaList;
}

QList<AyaModel *> PageManager::getAyaListBetween(const int firstId, const int secondId, const bool inclusive)
{
    QList<AyaModel *> ayaList;

    return ayaList;
}
