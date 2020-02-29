#ifndef BOOKMARKMANAGER_H
#define BOOKMARKMANAGER_H

#include <QObject>
#include "paging/AyaModel.h"

class BookmarkManager : public QObject
{
    Q_OBJECT
public:
    explicit BookmarkManager(QObject *parent = nullptr);

    QList<AyaModel *> getBookmarks(const QString quranText, const QString translation, const int lastId = 0, const int limit = 20) const;

    QStringList getBookmarkIds() const;
    bool checkBookmark(const int number);
    bool addBookmark(const int number);
    bool removeBookmark(const int number);
    bool clear();
    bool bookmarks(QStringList numberList);
    bool toogleBookmark(const int number);

signals:
};

#endif // BOOKMARKMANAGER_H
