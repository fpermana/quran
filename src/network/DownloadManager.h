#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QFile>

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

signals:

public slots:

private:
    QNetworkRequest currentRequest;
    QNetworkReply* _currentReply;

    QString url;
    QString filepath;
};

#endif // DOWNLOADMANAGER_H
