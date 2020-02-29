#include "Bookmarking.h"
#include "sqlite/BookmarkManager.h"

Bookmarking::Bookmarking(QObject *parent) : QObject(parent), m_settings(QSettings::IniFormat, QSettings::UserScope, QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION))
{
    m_settings.beginGroup("bookmarks");
}

void Bookmarking::dataReady(const bool status)
{
    if(status) {
        syncBookmarkSetting();
    }
}

bool Bookmarking::getStatus(const int ayaId)
{
    BookmarkManager *bm = new BookmarkManager;
    bool status = bm->checkBookmark(ayaId);
    bm->deleteLater();
    return status;
}

void Bookmarking::addBookmark(const int ayaId)
{
    BookmarkManager *bm = new BookmarkManager;
    if(bm->addBookmark(ayaId))
        m_settings.setValue(QString::number(ayaId), true);
    bm->deleteLater();
}

void Bookmarking::removeBookmark(const int ayaId)
{
    BookmarkManager *bm = new BookmarkManager;
    if(bm->removeBookmark(ayaId))
        m_settings.remove(QString::number(ayaId));
    bm->deleteLater();
}

void Bookmarking::getBookmarkList(const QString quranText, const QString translation)
{
    BookmarkManager *bm = new BookmarkManager;
    QList<AyaModel *> result = bm->getBookmarks(quranText, translation, 0);
    if(!result.isEmpty()) {
        AyaListModel *model = new AyaListModel;
        model->setAyaList(result);
        emit loaded(model);
    }
    bm->deleteLater();
}


void Bookmarking::loadMoreBookmarkList(const QString quranText, const QString translation, const int lastId)
{
    BookmarkManager *bm = new BookmarkManager;
    QList<AyaModel *> result = bm->getBookmarks(quranText, translation, lastId);
    emit loadedMore(result);
    bm->deleteLater();
}

void Bookmarking::checkBookmark(QList<AyaModel *> ayas)
{
    if(ayas.isEmpty())
        return;

    BookmarkManager *bm = new BookmarkManager;
    foreach(AyaModel *a, ayas) {
        bool marked = bm->checkBookmark(a->number());
        a->setMarked(marked);
    }
    bm->deleteLater();
}

void Bookmarking::syncBookmarkSetting()
{
//    m_settings.beginGroup("bookmarks");
    QStringList keys = m_settings.allKeys();
    QStringList markedList;
    foreach (QString key, keys) {
        bool marked = m_settings.value(key, false).toBool();
        if(marked) {
            markedList.append(key);
        }
        else {
            m_settings.remove(key);
        }
    }

    BookmarkManager *bm = new BookmarkManager;
    if(!markedList.empty()) {
        bm->clear();
        bm->bookmarks(markedList);
    }
    else {
        QStringList idList = bm->getBookmarkIds();
        foreach(QString id, idList) {
            m_settings.setValue(id, true);
        }
    }
    bm->deleteLater();
//    m_settings.endGroup();
}
