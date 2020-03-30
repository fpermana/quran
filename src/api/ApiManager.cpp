#include "ApiManager.h"
#include "GlobalConstants.h"
#include <QDebug>
#include <QFileInfo>
#include <QDir>
#include <QDateTime>
#include <QNetworkReply>
#include <QNetworkRequest>
//#include <QSslSocket>
#include <QUrl>

ApiManager::ApiManager(QObject *parent) : QObject(parent)
{
    man = new QNetworkAccessManager(this);
}

ApiManager::~ApiManager()
{
}

void ApiManager::openDB()
{
    checkDatabase();
}

void ApiManager::closeDB()
{
}

bool ApiManager::checkForUpdate()
{
    bool settingsExist = tableExist("settings");

    return true;
}

void ApiManager::dbExtracted(const bool isOk)
{

}

void ApiManager::pagesRequested()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    qDebug() << reply->readAll();
}

void ApiManager::checkDatabase()
{
//    qDebug() << QSslSocket::sslLibraryBuildVersionString();

    QNetworkRequest request;
    QUrl url(QString(API_URL));
    url.setPath("/paging/v1/total");
//    qDebug() << url.toString();
    request.setUrl(url);
//    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");

    QNetworkReply *reply = man->get(request);
    connect(reply, SIGNAL(finished()), this, SLOT(pagesRequested()));
//    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), reply, SLOT(ignoreSslErrors()));
    /*connect(reply, &QIODevice::readyRead, this, &MyClass::slotReadyRead);
    connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error),
            this, &MyClass::slotError);
    connect(reply, &QNetworkReply::sslErrors,
            this, &MyClass::slotSslErrors);*/
}

void ApiManager::prepareDatabase()
{

}

bool ApiManager::tableExist(const QString tableName)
{
    return true;
}

QVariantMap ApiManager::getDbSettings()
{
    QVariantMap dataMap;

    return dataMap;
}
