#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QVariant>
#include <QList>
#include "DownloadManager.h"

#define URL_KEY             "url"
#define FILEPATH_KEY        "filepath"

class Downloader : public QObject
{
    Q_OBJECT
public:
    explicit Downloader(QObject *parent = 0);

    void addDownloadMap(const QVariantMap &downloadMap);
    void start();
    void pause();
    void resume();

signals:

public slots:

private:
    QVariantList downloadedList, errorList;

    QHash<QString, DownloadManager *> dmList;
};

#endif // DOWNLOADER_H
