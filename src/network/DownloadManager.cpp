#include "DownloadManager.h"

DownloadManager::DownloadManager(QObject *parent) : QObject(parent)
{

}

void DownloadManager::getHeader()
{

}

QString DownloadManager::getUrl() const
{
    return url;
}

void DownloadManager::setUrl(const QString &value)
{
    url = value;
}

QString DownloadManager::getFilepath() const
{
    return filepath;
}

void DownloadManager::setFilepath(const QString &value)
{
    filepath = value;
}
