#ifndef SEARCHINGMANAGER_H
#define SEARCHINGMANAGER_H

#include <QObject>
#include "paging/AyaModel.h"

class SearchingManager : public QObject
{
    Q_OBJECT
public:
    explicit SearchingManager(QObject *parent = nullptr);

    QList<AyaModel *> search(const QString keywords, const QString quranText, const QString translation, const int from, const int limit, const int lastId = -1) const;

signals:

public slots:
};

#endif // SEARCHINGMANAGER_H
