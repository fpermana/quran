#include "Paging.h"
#include <QDebug>

#ifdef USE_API
#include "api/PageManager.h"
#else
#include "sqlite/PageManager.h"
#endif

Paging::Paging(QObject *parent) :
    QObject(parent), m_page(0), m_quranText(""), m_translation("")
{
    m_ayaList = new AyaListModel(this);
}

int Paging::page() const
{
    return m_page;
}

QString Paging::quranText() const
{
    return m_quranText;
}

QString Paging::translation() const
{
    return m_translation;
}

AyaListModel *Paging::ayaList() const
{
    return m_ayaList;
}

void Paging::setPage(int page)
{
    if (m_page == page)
        return;

    m_page = page;

    getAyaList();
    emit pageChanged(m_page);
}

void Paging::setQuranText(QString quranText)
{
    if (m_quranText == quranText)
        return;

    m_quranText = quranText;

    getAyaList();
    emit quranTextChanged(m_quranText);
}

void Paging::setTranslation(QString translation)
{
    if (m_translation == translation)
        return;

    m_translation = translation;

    getAyaList();
    emit translationChanged(m_translation);
}

void Paging::getAyaList()
{
    if(m_page > 0 && !m_quranText.isEmpty() && !m_translation.isEmpty()) {
        PageManager *pageManager = new PageManager(m_quranText, m_translation);
        QPair<int,int> currentPage = pageManager->getSuraAyaStart(m_page);
        QPair<int,int> nextPage = pageManager->getSuraAyaStart(m_page+1);

        int currentId = 0;
        int nextId = 0;
        if(currentPage.first > 0 && currentPage.second > 0) {
            currentId = pageManager->getIdBySuraAya(currentPage.first,currentPage.second);
        }
        if(nextPage.first > 0 && nextPage.second > 0) {
            nextId = pageManager->getIdBySuraAya(nextPage.first,nextPage.second);
        }

        QList<AyaModel*> ayaList;
        if(currentId > 0 && nextId > 0) {
            ayaList = pageManager->getAyaListBetween(currentId,nextId);
        }
        else if(currentId > 0) {
            ayaList = pageManager->getAyaListFrom(currentId);
        }

        if(!ayaList.isEmpty()) {
            m_ayaList->setAyaList(ayaList);
        }
    }
}
