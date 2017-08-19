#include "DownloadManager.h"
#include <QDir>
#include <QFileInfo>
#include <QList>

DownloadManager::DownloadManager(QObject *parent) : QObject(parent)
  , pManager(0)
  , currentReply(0)
  , pFile(0)
  , nDownloadTotal(0)
  , bAcceptRanges(false)
  , nDownloadSize(0)
  , nDownloadSizeAtPause(0)
  , networkError(QNetworkReply::NoError)
{
}

DownloadManager::~DownloadManager()
{
    currentReply = 0;
    if (pManager)
        pManager->deleteLater();

    if(pFile && pFile->isOpen())
        pFile->close();

    pFile = 0;
    pManager = 0;
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

void DownloadManager::download()
{
    if(filepath.isEmpty() || url.isEmpty())
        return;

    timer.start();

    QFileInfo fileInfo(filepath);
    if(!QDir(fileInfo.absolutePath()).exists())
        QDir().mkpath(fileInfo.absolutePath());

    nDownloadSize = 0;
    nDownloadSizeAtPause = 0;

    pManager = new QNetworkAccessManager(this);
    currentRequest = QNetworkRequest(QUrl(url));
    currentReply = pManager->head(currentRequest);

//    timeoutTimer.setInterval(DOWNLOAD_TIMEOUT_MSEC);
//    timeoutTimer.setSingleShot(true);
//    connect(&timeoutTimer, SIGNAL(timeout()), this, SLOT(timeout()));
//    timeoutTimer.start();

    connect(currentReply, SIGNAL(finished()), this, SLOT(finishedHead()));
//    connect(currentReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(error(QNetworkReply::NetworkError)));
}

void DownloadManager::finishedHead()
{
    if(currentReply->error() != QNetworkReply::NoError) {
        qDebug() << __FUNCTION__ << currentReply->errorString();
        networkError = currentReply->error();
        emit downloadCompleted();
        return;
    }

    timeoutTimer.stop();
    bAcceptRanges = false;

    QList<QByteArray> list = currentReply->rawHeaderList();
    foreach (QByteArray header, list)
    {
        qDebug() << header << currentReply->rawHeader(header);
    }
    if(currentReply->hasRawHeader("Accept-Ranges"))
    {
        QString qstrAcceptRanges = currentReply->rawHeader("Accept-Ranges");
        bAcceptRanges = (qstrAcceptRanges.compare("bytes", Qt::CaseInsensitive) == 0);
    }

    nDownloadTotal = currentReply->header(QNetworkRequest::ContentLengthHeader).toULongLong();

    QFileInfo fileInfo(filepath);
    QString partFilename(QString("%1.part").arg(filepath));
    if(fileInfo.exists()) {
        currentReply->deleteLater();
        emit downloadCompleted();
    }
    else {
        currentRequest.setRawHeader("Connection", "Keep-Alive");
        currentRequest.setAttribute(QNetworkRequest::HttpPipeliningAllowedAttribute, true);
        pFile = new QFile(partFilename);
        if (!bAcceptRanges)
        {
            pFile->remove();
        }
        pFile->open(QIODevice::ReadWrite | QIODevice::Append);

        qDebug() << "END";
        nDownloadSizeAtPause = pFile->size();
        downloadContent();
    }
}

void DownloadManager::finishedContent()
{
    qDebug() << __FUNCTION__;
//    timeoutTimer.stop();
    pFile->close();

    QString partFilename = QString("%1.part").arg(filepath);

    if(currentReply->error() != QNetworkReply::NoError) {
        if(currentReply->error() == QNetworkReply::UnknownContentError) {
            if(QFile::remove(partFilename)) {
                qDebug() << partFilename << "removed";
            }
        }
//        emit downloadError(currentReply->error(), currentReply->errorString());
    }
    else {
        QFile::remove(filepath);
        pFile->rename(partFilename, filepath);

        pFile = 0;
        currentReply = 0;
        pManager->deleteLater();
        pManager = 0;

        emit downloadCompleted();
    }
}

void DownloadManager::error(QNetworkReply::NetworkError e)
{
    qDebug() << __FUNCTION__ << e;
}

void DownloadManager::downloadContent()
{
    qDebug() << __FUNCTION__;
    if (bAcceptRanges)
    {
        QByteArray rangeHeaderValue = "bytes=";
        if (nDownloadTotal > 0)
        {
            if(nDownloadSizeAtPause>nDownloadTotal) {
                nDownloadSizeAtPause=nDownloadTotal;
                finishedContent();
                return;
            }
        }
        rangeHeaderValue += QByteArray::number(nDownloadSizeAtPause) + "-" + QByteArray::number(nDownloadTotal);
        qDebug() << "Range" << rangeHeaderValue;
        currentRequest.setRawHeader("Range", rangeHeaderValue);
    }
    currentReply = pManager->get(currentRequest);

//    timeoutTimer.setInterval(DOWNLOAD_TIMEOUT_MSEC);
//    timeoutTimer.setSingleShot(true);
//    connect(&_timeoutTimer, SIGNAL(timeout()), this, SLOT(timeout()));
//    timeoutTimer.start();

    connect(currentReply, SIGNAL(finished()), this, SLOT(finishedContent()));
    connect(currentReply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(progress(qint64,qint64)));
    connect(currentReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(error(QNetworkReply::NetworkError)));
}

QNetworkReply::NetworkError DownloadManager::getError() const
{
    return networkError;
}

void DownloadManager::progress(qint64 bytesReceived, qint64 bytesTotal)
{
    double newSpeed = bytesReceived * 1000.0 / timer.elapsed();
//    timeoutTimer.stop();
    nDownloadSize = nDownloadSizeAtPause + bytesReceived;

    pFile->write(currentReply->readAll());
    emit downloadProgress(newSpeed, (nDownloadSizeAtPause + bytesReceived), (nDownloadSizeAtPause + bytesTotal));

//    _timeoutTimer.start(DOWNLOAD_TIMEOUT_MSEC);
}
