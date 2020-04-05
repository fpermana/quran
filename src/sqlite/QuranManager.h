#ifndef QURANMANAGER_H
#define QURANMANAGER_H

#include <QObject>
#include <QList>
#include "paging/AyaModel.h"
#include "quran/SuraModel.h"

class QuranManager : public QObject
{
    Q_OBJECT
public:
    explicit QuranManager(QObject *parent = nullptr);

public:
    int pageCount() const;
    AyaModel *getBismillah(const QString quranText, const QString translation) const;
    AyaModel *getAya(const int sura, const int aya, const QString quranText, const QString translation) const;
    int getSuraPage(const int sura) const;
    int getSuraAyaPage(const int sura, const int aya) const;
    QList<SuraModel *> getSuraList() const;

signals:

public slots:
};

#endif // QURANMANAGER_H
