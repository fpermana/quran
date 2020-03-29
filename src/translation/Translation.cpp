#include "Translation.h"
#include <QDebug>
#include <QThread>

#include "translation/TranslationParser.h"
#ifdef USE_API
#include "api/TranslationManager.h"
#else
#include "GlobalFunctions.h"
#include "downloader/DownloadManager.h"
#include "sqlite/TranslationManager.h"
#endif

Translation::Translation(QObject *parent) : QObject(parent)
{

}

void Translation::installTranslation(QString tid)
{
    int oldValue = m_downloadMap.value(tid,NotInstalled).toInt();
    if(oldValue < Queued)
        m_downloadMap.insert(tid, Queued);

    QString current = "";

    for(QVariantMap::const_iterator iter = m_downloadMap.begin(); iter != m_downloadMap.end(); ++iter) {
        qDebug() << iter.key() << iter.value();
        QString key = iter.key();
        int value = iter.value().toInt();

        if((key == tid && value > Downloading) || value == Downloading) {
            current = key;
            break;
        }
    }

    if(current.isEmpty()) {
//        qDebug() << "downloading " << tid;
        downloadTranslation(tid);
    }
}

void Translation::uninstallTranslation(QString tid)
{
    TranslationManager *tm = new TranslationManager;
    if(tm->uninstallTranslation(tid)) {
        m_downloadMap.insert(tid, Removed);
        emit translationUninstalled(tid);
    }
}

void Translation::dataReady(const bool status)
{

}

void Translation::getActiveTranslation()
{
    TranslationManager *tm = new TranslationManager;
    QList<TranslationModel *> translationList = tm->getInstalledTranslation();
    TranslationListModel *model = new TranslationListModel;
    model->setTranslationList(translationList);
    emit activeTranslationLoaded(model);
}

void Translation::getAllTranslation()
{
    TranslationManager *tm = new TranslationManager;
    QList<TranslationModel *> translationList = tm->getAllTranslation();
    TranslationListModel *model = new TranslationListModel;
    model->setTranslationList(translationList);
    emit translationLoaded(model);
}

int Translation::getStatus(const QString tid) const
{
    return m_downloadMap.value(tid,0).toInt();
}

void Translation::downloadTranslation(QString tid)
{
#ifndef USE_API
    QString filepath = QString("%1%2.txt").arg(GlobalFunctions::translationLocation()).arg(tid);
    QString url = QString("http://tanzil.net/trans/?transID=%1&type=txt-2").arg(tid);
    DownloadManager *dm = new DownloadManager;
    connect(dm, SIGNAL(downloadCompleted()), this, SLOT(translationDownloaded()));
    dm->setFilepath(filepath);
    dm->setUrl(url);
    dm->download();

    m_downloadMap.insert(tid, Downloading);
#endif
}

void Translation::translationDownloaded()
{
#ifndef USE_API
    DownloadManager *d = qobject_cast<DownloadManager *>(sender());
    if(!d || d->getError()) {
        d->deleteLater();
        return;
    }
    d->deleteLater();
#endif

    QString current = "";

    for(QVariantMap::const_iterator iter = m_downloadMap.begin(); iter != m_downloadMap.end(); ++iter) {
        qDebug() << iter.key() << iter.value();
//        QString key = iter.key();
        int value = iter.value().toInt();

        if(value == Downloading) {
            current = iter.key();
            break;
        }
    }

    if(!current.isEmpty())
        parseTranslation(current);
}

void Translation::parseTranslation(QString tid)
{
#ifndef USE_API
    QString filepath = QString("%1%2.txt").arg(GlobalFunctions::translationLocation()).arg(tid);
    QString tableName = tid.replace(".","_");

    qDebug() << filepath << tableName;

    QThread* thread = new QThread;
    TranslationParser *tp = new TranslationParser();
    tp->setFilepath(filepath);
    tp->setTableName(tableName);
    tp->moveToThread(thread);
//        connect(p, SIGNAL(error(QString)), this, SLOT(errorString(QString)));
    connect(thread, SIGNAL(started()), tp, SLOT(parse()));
    connect(tp, SIGNAL(parsingFinished()), thread, SLOT(quit()));
    connect(tp, SIGNAL(parsingFinished()), this, SLOT(translationParsed()));
    connect(tp, SIGNAL(parsingFinished()), tp, SLOT(deleteLater()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
    m_downloadMap.insert(tid, Installing);
#endif
}

void Translation::translationParsed()
{
    QString current = "";

    for(QVariantMap::const_iterator iter = m_downloadMap.begin(); iter != m_downloadMap.end(); ++iter) {
        int value = iter.value().toInt();

        if(value == Installing) {
            current = iter.key();
            break;
        }
    }

    if(!current.isEmpty()) {
        current = current.replace("_",".");
        TranslationManager *tm = new TranslationManager;
        if(tm->installTranslation(current)) {
            m_downloadMap.insert(current, Installed);
            emit translationInstalled(current);
        }
    }
}

void Translation::processNextQueue()
{
    QString current = "";

    for(QVariantMap::const_iterator iter = m_downloadMap.begin(); iter != m_downloadMap.end(); ++iter) {
//        QString key = iter.key();
        int value = iter.value().toInt();

        if(value == Queued) {
            current = iter.key();
            break;
        }
    }

    if(!current.isEmpty()) {
        downloadTranslation(current);
    }
}
