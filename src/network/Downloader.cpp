#include "Downloader.h"
#include <QCryptographicHash>

Downloader::Downloader(QObject *parent) : QObject(parent)
{
}

void Downloader::addDownloadMap(const QVariantMap &downloadMap)
{
    QString url = downloadMap.value(URL_KEY, "").toString();
    QString filepath= downloadMap.value(FILEPATH_KEY, "").toString();

    if(!url.isEmpty() && !filepath.isEmpty()) {
        QString hash = QString(QCryptographicHash::hash(url.toLatin1(),QCryptographicHash::Md5).toHex());
        if(!dmList.contains(hash)) {
            DownloadManager *dm = new DownloadManager(this);
            dm->setUrl(url);
            dm->setFilepath(filepath);
            dmList.insert(hash, dm);
        }
    }
}

void Downloader::start()
{
    if(!dmList.isEmpty()) {

    }
}

void Downloader::pause()
{

}

void Downloader::resume()
{

}
