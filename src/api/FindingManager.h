#ifndef FINDINGMANAGER_H
#define FINDINGMANAGER_H

#include <QObject>
#include "paging/AyaModel.h"

class FindingManager : public QObject
{
    Q_OBJECT
public:
    explicit FindingManager(QObject *parent = nullptr);

    QList<AyaModel *> find(const QString keywords, const QString quranText, const QString translation, const int from, const int limit, const int lastId = -1) const;

signals:

public slots:
};

#endif // FINDINGMANAGER_H
