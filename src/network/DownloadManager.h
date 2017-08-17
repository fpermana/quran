#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QFile>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QTime>
#include <QTimer>

class DownloadManager : public QObject
{
    Q_OBJECT
public:
    explicit DownloadManager(QObject *parent = 0);

    void getHeader();

    QString getUrl() const;
    void setUrl(const QString &value);

    QString getFilepath() const;
    void setFilepath(const QString &value);

    void download();

signals:
    void downloadProgress(const double speed, const qint64 bytesReceived, const qint64 bytesTotal);
    void downloadCompleted();

private slots:
    void finishedHead();
    void finishedContent();
    void error(QNetworkReply::NetworkError e);
    void progress(qint64 bytesReceived, qint64 bytesTotal);

private:
    void downloadContent();

    QNetworkAccessManager* pManager;
    QNetworkRequest currentRequest;
    QNetworkReply* currentReply;

    QString url;
    QString filepath;

    QFile* pFile;
    qint64 nDownloadTotal;
    bool bAcceptRanges;
    qint64 nDownloadSize;
    qint64 nDownloadSizeAtPause;
    QTimer timeoutTimer;
    QTime timer;
};

#endif // DOWNLOADMANAGER_H
