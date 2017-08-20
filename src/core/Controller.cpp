#include "Controller.h"
#include "GlobalFunctions.h"
#include "GlobalConstants.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QStringList>
#include "helper/FileExtractorWorker.h"
#include "database/TranslationParser.h"
#include "network/DownloadManager.h"

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::init()
{
    settings = new Settings(this);
    settings->restoreSettings();
//    connect(this, SIGNAL(currentPageChanged(int)), settings, SLOT(setCurrentPage(int)));
    connect(settings, SIGNAL(settingsChanged()), this, SLOT(refresh()));

    manager = new DbManager(this);
    checkDatabase();

//    downloader = new Downloader(this);

    indexModel = new SqlQueryModel(this);
    indexModel->setQuery("SELECT * FROM suras", *manager->getDb());

    translationModel = new SqlQueryModel(this);
    translationModel->setQuery("SELECT * FROM translations WHERE is_default != 1 AND visible = 1", *manager->getDb());

    activeTranslationModel = new SqlQueryModel(this);
    activeTranslationModel->setQuery("SELECT * FROM translations WHERE installed = 1", *manager->getDb());
    qDebug() << "activeTranslationModel" << activeTranslationModel->rowCount();
    qDebug() << "translationModel" << translationModel->rowCount();
    /*int c = translationModel->rowCount();
    for(int i=0; i<c; i++) {
//        qDebug() << translationModel->data(translationModel->index(i,0),262);
        downloadTranslation(translationModel->data(translationModel->index(i,0),262).toString());
//        if(i==3)
//            break;
    }*/
//    qDebug() << translationModel->roleNames();

    preview = new PageModel(manager->getDb(), this);
    preview->setTextType(settings->getTextType());
    preview->setTranslation(settings->getTranslation());
    preview->getAya(1,1);

    QVariantMap bismillahMap = manager->getQuranText(1,1, settings->getTextType());
    bismillah = bismillahMap.value("text").toString();

    pages = manager->getPages();

    changePage(settings->getCurrentPage());
}

void Controller::checkDatabase(const bool reset)
{
    QString filepath = GlobalFunctions::databaseLocation();
    QFile file(filepath);
    if(file.exists() && reset)
        file.remove();

    if(!file.exists()) {
        QFile dbSrc(QString(":/db/%1.zip").arg(DB_NAME));
        QFileInfo fileInfo(QString("%1.zip").arg(filepath));
        QDir dbDir = fileInfo.absoluteDir();
        if(!dbDir.exists())
            dbDir.mkpath(fileInfo.absolutePath());
        if(fileInfo.exists()) {
            QFile f(fileInfo.absoluteFilePath());
#ifdef Q_OS_WIN
            f.setPermissions(QFile::ReadOther|QFile::WriteOther);
#endif
            f.remove(fileInfo.absoluteFilePath());
        }
        if(!dbSrc.copy(fileInfo.absoluteFilePath())) {
            qDebug() << dbSrc.errorString();
        }
        else {

            QVariantMap fileMap;
            fileMap.insert(SOURCE_FILEPATH_KEY, fileInfo.absoluteFilePath());
//            fileMap.insert(EXTRACT_DIR_KEY, GlobalFunctions::dataLocation());

            QVariantList fileList;
            fileList.append(fileMap);
            FileExtractorWorker *f = new FileExtractorWorker;
            f->setFileZipList(fileList);
            f->startExtracting();
            f->deleteLater();
            QFile::remove(fileInfo.absoluteFilePath());
        }
    }

    if(QFile::exists(filepath))
        manager->init(filepath);
    else
        qDebug() << "NOT EXIST" << filepath;
}

SqlQueryModel *Controller::getIndexModel() const
{
    return indexModel;
}

SqlQueryModel *Controller::getTranslationModel() const
{
    return translationModel;
}

SqlQueryModel *Controller::getActiveTranslationModel() const
{
    return activeTranslationModel;
}

void Controller::addBookmark(const int quranTextId)
{
    qDebug() << __FUNCTION__ << quranTextId;
    manager->addBookmark(quranTextId);
}

PageModel *Controller::getPage(const int page) const
{
    return pageModelHash.value(page,0);
}

void Controller::gatherPage(const int page)
{
    if(page<1 || page>pages)
        return;

    PageModel *model;
    QStringList pageData;

    if(!pageModelHash.contains(page)) {
        model = new PageModel(manager->getDb(), this);

        pageData = manager->getPage(page);
        if(pageData.count() == 2 || pageData.count() == 4) {
            model->setTextType(settings->getTextType());
            model->setTranslation(settings->getTranslation());
            model->setPage(page);
            model->setJuz(manager->getJuz(pageData.at(0).toInt(), pageData.at(1).toInt()));
            model->setSura(manager->getSura(pageData.at(0).toInt()));

            if(pageData.count() == 4) {
                model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt(), pageData.at(2).toInt(), pageData.at(3).toInt());
            }
            else if(pageData.count() == 2) {
                model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt());
            }

            pageModelHash.insert(page,model);
        }
    }

    if(pageModelHash.contains(page)) {
        model = pageModelHash.value(page);
        if(model->getPage() != page || model->getTextType() != settings->getTextType() || model->getTranslation() != settings->getTranslation()) {
            model->setTextType(settings->getTextType());
            model->setTranslation(settings->getTranslation());
            model->refresh();
        }
    }
}

void Controller::changePage(const int page)
{
    for (int i = page-1; i <= page+1; i++) {
        gatherPage(i);
    }
}

void Controller::openSura(const int suraId)
{
    int page = manager->openSura(suraId);
    changePage(page);

    emit pageChanged(page);
}

void Controller::downloadTranslation(const QString tid)
{
    bool empty = translationList.isEmpty();
    if(!translationList.contains(tid))
        translationList.append(tid);
    if(empty) {
        QString filepath = QString("%1trans/%2.txt").arg(GlobalFunctions::dataLocation()).arg(tid);
        QString url = QString("http://tanzil.net/trans/?transID=%1&type=txt-2").arg(tid);

        DownloadManager *dm = new DownloadManager;
        connect(dm, SIGNAL(downloadCompleted()), this, SLOT(translationDownloaded()));
        dm->setFilepath(filepath);
        dm->setUrl(url);
        dm->download();
    }
}

void Controller::removeTranslation(const QString tid)
{
    if(manager->uninstallTranslation(tid)) {
        translationModel->setQuery("SELECT * FROM translations WHERE is_default != 1 AND visible = 1", *manager->getDb());
        activeTranslationModel->setQuery("SELECT * FROM translations WHERE installed = 1", *manager->getDb());

        QString uTid = QString(tid);
        uTid = uTid.replace(".","_");

        if(uTid == settings->getTranslation()) {
            settings->setTranslation(DEFAULT_TRANSLATION_KEY);
            preview->setTranslation(settings->getTranslation());
            preview->refresh();
            refresh();
        }
        emit translationChanged();
    }
}

double Controller::getYPosition(const int page)
{
    double y = manager->getYPosition(page);
    return y;
}

double Controller::setYPosition(const int page, const double position)
{
    manager->setYPosition(page, position);
}

QString Controller::getBismillah() const
{
    return bismillah;
}

void Controller::refresh()
{
    QVariantMap bismillahMap = manager->getQuranText(1,1, settings->getTextType());
    bismillah = bismillahMap.value("text").toString();

    changePage(settings->getCurrentPage());

    emit refreshed();
}

void Controller::translationDownloaded()
{
    DownloadManager *d = qobject_cast<DownloadManager *>(sender());
    if(!d) {
        translationList.takeFirst();
        d->deleteLater();
        return;
    }
    if(d->getError()) {
        translationList.takeFirst();
        d->deleteLater();
        return;
    }

    parseTranslation();
    d->deleteLater();
}

void Controller::parseTranslation()
{
    QString tid = translationList.first();
    QString filepath = QString("%1trans/%2.txt").arg(GlobalFunctions::dataLocation()).arg(tid);
    QString tableName = tid.replace(".","_");

    QThread* thread = new QThread;
    TranslationParser *p = new TranslationParser(tableName,*manager->getDb());
    p->setFilepath(filepath);
    p->moveToThread(thread);
//        connect(p, SIGNAL(error(QString)), this, SLOT(errorString(QString)));
    connect(thread, SIGNAL(started()), p, SLOT(parse()));
    connect(p, SIGNAL(parsingFinished()), thread, SLOT(quit()));
    connect(p, SIGNAL(parsingFinished()), this, SLOT(parsingFinished()));
//        connect(p, SIGNAL(parsingFinished()), p, SLOT(deleteLater()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
}

void Controller::parsingFinished()
{
    TranslationParser *p = qobject_cast<TranslationParser *>(sender());
    if(!p)
        return;
    QString tid = translationList.takeFirst();
    manager->installTranslation(tid);
    qDebug() << __FUNCTION__ << tid;
    bool empty = translationList.isEmpty();
    if(!empty) {
        QString tid = translationList.first();
        QString filepath = QString("%1trans/%2.txt").arg(GlobalFunctions::dataLocation()).arg(tid);
        QString url = QString("http://tanzil.net/trans/?transID=%1&type=txt-2").arg(tid);

        DownloadManager *dm = new DownloadManager(this);
        connect(dm, SIGNAL(downloadCompleted()), this, SLOT(translationDownloaded()));
        dm->setFilepath(filepath);
        dm->setUrl(url);
        dm->download();
    }
    else {
        translationModel->setQuery("SELECT * FROM translations WHERE is_default != 1 AND visible = 1", *manager->getDb());
        activeTranslationModel->setQuery("SELECT * FROM translations WHERE installed = 1", *manager->getDb());
        emit translationChanged();
    }
    p->deleteLater();
}

Settings *Controller::getSettings() const
{
    return settings;
}

PageModel *Controller::getPreview() const
{
    return preview;
}

PageModel *Controller::getCurrentPage() const
{
    return pageModelHash.value(settings->getCurrentPage(),0);
}

int Controller::getPages() const
{
    return pages;
}
