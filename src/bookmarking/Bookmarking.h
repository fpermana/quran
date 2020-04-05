#ifndef BOOKMARKING_H
#define BOOKMARKING_H

#include <QObject>
#include <QSettings>
#include "paging/AyaListModel.h"
#include "GlobalConstants.h"

class Bookmarking : public QObject
{
    Q_OBJECT
public:
    explicit Bookmarking(QObject *parent = nullptr);

signals:
    void loaded(AyaListModel* ayaList);
    void loadedMore(QList<AyaModel*> ayas);
    void bookmarkRemoved(const int ayaId);
    void bookmarkAdded(const int ayaId);

public slots:
    void dataReady(const bool status);
    bool getStatus(const int ayaId);
    void addBookmark(const int ayaId);
    void removeBookmark(const int ayaId);
    void getBookmarkList(const QString quranText = DEFAULT_QURAN_TEXT, const QString translation = DEFAULT_TRANSLATION);
    void loadMoreBookmarkList(const QString quranText, const QString translation, const int lastId);

    void checkBookmark(QList<AyaModel*> ayas);

private:
    void syncBookmarkSetting();

    QSettings m_settings;
};

#endif // BOOKMARKING_H
