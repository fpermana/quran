#ifndef SEARCHING_H
#define SEARCHING_H

#include <QObject>
#include "paging/AyaListModel.h"
#include "GlobalConstants.h"

class Searching : public QObject
{
    Q_OBJECT
public:
    explicit Searching(QObject *parent = nullptr);

signals:
    void found(QString keyword, AyaListModel* ayaList);
    void foundMore(QList<AyaModel*> ayas);
    void foundNew(QString keyword, AyaListModel* ayaList);

public slots:
    void search(const QString keyword, const QString quranText = DEFAULT_QURAN_TEXT, const QString translation = DEFAULT_TRANSLATION, const int from = 0, const int limit = 20, const int lastId = -1);
    void searchMore(const QString keyword, const QString quranText = DEFAULT_QURAN_TEXT, const QString translation = DEFAULT_TRANSLATION, const int from = 0, const int limit = 20, const int lastId = -1);
    void searchNew(const QString keyword, const QString quranText = DEFAULT_QURAN_TEXT, const QString translation = DEFAULT_TRANSLATION, const int from = 0, const int limit = 20, const int lastId = -1);

private:
    QString highlightMatching(QString haystack, const QString &needle);
};

#endif // SEARCHING_H
