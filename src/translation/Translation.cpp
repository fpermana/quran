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
    if(oldValue == NotInstalled || oldValue == Uninstalled) {
        m_downloadMap.insert(tid, Queued);
//        downloadTranslation(tid);
        emit statusChanged(tid, Queued);
        processNextQueue();
    }
}

void Translation::uninstallTranslation(QString tid)
{
    int oldValue = m_downloadMap.value(tid,NotInstalled).toInt();
    if(oldValue == NotInstalled || oldValue == Installed) {
        m_downloadMap.insert(tid, Uninstalling);
//        downloadTranslation(tid);
        emit statusChanged(tid, Uninstalling);
        processNextQueue();
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
    tm->deleteLater();
}

void Translation::getAllTranslation()
{
    TranslationManager *tm = new TranslationManager;
    QList<TranslationModel *> translationList = tm->getAllTranslation();
    TranslationListModel *model = new TranslationListModel;
    model->setTranslationList(translationList);
    emit translationLoaded(model);
    tm->deleteLater();
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
    emit statusChanged(tid, Downloading);
#endif
}

void Translation::removeTranslation(QString tid)
{
    TranslationManager *tm = new TranslationManager;
    QString tableName(tid);
    tableName.replace(".","_");
    if(tm->deleteTranslationTable(tableName) && tm->uninstallTranslation(tid)) {
        m_downloadMap.insert(tid, Uninstalled);
//        emit translationUninstalled(tid);
        emit statusChanged(tid, Uninstalled);
        processNextQueue();
    }
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
//        qDebug() << iter.key() << iter.value();
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
//    qDebug() << tid;
    m_downloadMap.insert(tid, Installing);
//    emit translationInstalling(tid);
    emit statusChanged(tid, Installing);
    QString filepath = QString("%1%2.txt").arg(GlobalFunctions::translationLocation()).arg(tid);
    QString tableName = tid.replace(".","_");

//    qDebug() << filepath << tableName;

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
#endif
}

void Translation::translationParsed()
{
    QString tid = "";

    for(QVariantMap::const_iterator iter = m_downloadMap.begin(); iter != m_downloadMap.end(); ++iter) {
        int value = iter.value().toInt();

        if(value == Installing) {
            tid = iter.key();
            break;
        }
    }

    if(!tid.isEmpty()) {
        tid = tid.replace("_",".");
        TranslationManager *tm = new TranslationManager;
        if(tm->installTranslation(tid)) {
            m_downloadMap.insert(tid, Installed);
//            emit translationInstalled(current);
            emit statusChanged(tid, Installed);
            processNextQueue();
        }
    }
}

void Translation::processNextQueue()
{
    QString inProgressTid = "";
    QString queuingTid = "";
    QString uninstallingTid = "";

    for(QVariantMap::const_iterator iter = m_downloadMap.begin(); iter != m_downloadMap.end(); ++iter) {
//        QString key = iter.key();
        int value = iter.value().toInt();

        if(value == Queued && queuingTid.isEmpty()) {
            queuingTid = iter.key();
        }
        else if(value == Uninstalling && uninstallingTid.isEmpty()) {
            uninstallingTid = iter.key();
        }
        else if(value ==  Downloading || value == Installing) {
            inProgressTid = iter.key();
        }
    }

    if(inProgressTid.isEmpty()) {
        if(!uninstallingTid.isEmpty())
            removeTranslation(uninstallingTid);
        else if(!queuingTid.isEmpty())
            downloadTranslation(queuingTid);
    }
}
