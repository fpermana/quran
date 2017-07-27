#include "Controller.h"
#include "GlobalFunctions.h"
#include "GlobalConstants.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QStringList>
#include "helper/FileExtractorWorker.h"

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
    checkDatabase(true);

    indexModel = new SqlQueryModel(this);
    indexModel->setQuery("SELECT * FROM suras", *manager->getDb());

    translationModel = new SqlQueryModel(this);
    translationModel->setQuery("SELECT * FROM translations", *manager->getDb());

    activeTranslationModel = new SqlQueryModel(this);
    activeTranslationModel->setQuery("SELECT * FROM translations WHERE active = 1", *manager->getDb());

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
            fileMap.insert(FILEPATH_KEY, fileInfo.absoluteFilePath());
//            fileMap.insert(EXTRACT_PATH_KEY, GlobalFunctions::dataLocation());

            QVariantList fileList;
            fileList.append(fileMap);
            FileExtractorWorker *f = new FileExtractorWorker;
            f->setFileZipList(fileList);
            f->startExtracting();
            f->deleteLater();
            QFile::remove(fileInfo.absoluteFilePath());
        }
    }

    manager->init(filepath);
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
