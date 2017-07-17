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
    firstPage = midPage = lastPage = 0;

    settings = new Settings(this);
    settings->restoreSettings();
    connect(this, SIGNAL(currentPageChanged(int)), settings, SLOT(setCurrentPage(int)));
    connect(settings, SIGNAL(settingsChanged()), this, SLOT(refresh()));

    manager = new DbManager(this);
    checkDatabase(true);

    indexModel = new SqlQueryModel(this);
    indexModel->setQuery("SELECT * FROM suras", *manager->getDb());

    /*firstPage = new PageModel(manager->getDb(), this);
    midPage = new PageModel(manager->getDb(), this);
    lastPage = new PageModel(manager->getDb(), this);*/
    preview = new PageModel(manager->getDb(), this);
    preview->setTextType(settings->getTextType());
    preview->setTranslation(settings->getTranslation());
    preview->getAya(1,1);

    QVariantMap bismillahMap = manager->getQuranText(1,1, settings->getTextType());
    bismillah = bismillahMap.value("text").toString();

    currentPage = settings->getCurrentPage();
    pages = manager->getPages();
    adjustPage();
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
        if(fileInfo.exists())
            QFile::remove(fileInfo.absoluteFilePath());
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

void Controller::adjustPage()
{
    PageModel *model;
    QStringList pageData;
    for(int i=(currentPage-1); i<=(currentPage+1); i++)
    {
        if(i>=1 && i<=pages)
        {
            /*if(i==currentPage-1)
                model = firstPage;
            else if(i==currentPage)
                model = midPage;
            else if(i==currentPage+1)
                model = lastPage;

            if(model->getPage() != i) {
                pageData = manager->getPage(i);
                qDebug() << pageData;
                if(pageData.count() == 4) {
                    model->setJuz(manager->getJuz(pageData.at(0).toInt(), pageData.at(1).toInt()));
                    model->setSura(manager->getSura(pageData.at(0).toInt()));
                    model->setPage(i);
                    model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt(), pageData.at(2).toInt(), pageData.at(3).toInt());
                }
                else if(pageData.count() == 2) {
                    model->setJuz(manager->getJuz(pageData.at(0).toInt(), pageData.at(1).toInt()));
                    model->setSura(manager->getSura(pageData.at(0).toInt()));
                    model->setPage(i);
                    model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt());
                }
            }*/

            if(!pageModelHash.contains(i)) {
                model = new PageModel(manager->getDb(), this);

                if(model->getPage() != i || model->getTextType() != settings->getTextType() || model->getTranslation() != settings->getTranslation()) {
                    pageData = manager->getPage(i);
                    if(pageData.count() == 2 || pageData.count() == 4) {
                        model->setTextType(settings->getTextType());
                        model->setTranslation(settings->getTranslation());
                        model->setPage(i);
                        model->setJuz(manager->getJuz(pageData.at(0).toInt(), pageData.at(1).toInt()));
                        model->setSura(manager->getSura(pageData.at(0).toInt()));

                        if(pageData.count() == 4) {
                            model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt(), pageData.at(2).toInt(), pageData.at(3).toInt());
                        }
                        else if(pageData.count() == 2) {
                            model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt());
                        }

                        pageModelHash.insert(i,model);
                    }
                }
            }

            if(pageModelHash.contains(i)) {
                model = pageModelHash.value(i);
                if(model->getPage() != i || model->getTextType() != settings->getTextType() || model->getTranslation() != settings->getTranslation()) {
                    model->setTextType(settings->getTextType());
                    model->setTranslation(settings->getTranslation());
                    model->refresh();
                }
                if(i==currentPage-1)
                    firstPage = model;
                else if(i==currentPage)
                    midPage = model;
                else if(i==currentPage+1)
                    lastPage = model;
            }
        }
    }
}

SqlQueryModel *Controller::getIndexModel() const
{
    return indexModel;
}

void Controller::bookmark(const int quranTextId)
{

}

QString Controller::getBismillah() const
{
    return bismillah;
}

void Controller::refresh()
{
    QVariantMap bismillahMap = manager->getQuranText(1,1, settings->getTextType());
    bismillah = bismillahMap.value("text").toString();

    PageModel *model;
    for (int i = 0; i < 3; i++) {
        if(i==0)
            model = firstPage;
        else if(i==1)
            model = midPage;
        else if(i==2)
            model = lastPage;

        if(model == 0)
            continue;

        if(model->getTextType() != settings->getTextType() || model->getTranslation() != settings->getTranslation()) {
            model->setTextType(settings->getTextType());
            model->setTranslation(settings->getTranslation());
            model->refresh();
        }
    }

    emit refreshed();
}

Settings *Controller::getSettings() const
{
    return settings;
}

PageModel *Controller::getLastPage() const
{
    return lastPage;
}

PageModel *Controller::getPreview() const
{
    return preview;
}

PageModel *Controller::getMidPage() const
{
    return midPage;
}

PageModel *Controller::getFirstPage() const
{
    return firstPage;
}

int Controller::getPages() const
{
    return pages;
}

int Controller::getCurrentPage() const
{
    return currentPage;
}

void Controller::setCurrentPage(const int page)
{
    if(currentPage == page)
        return;

    currentPage = page;
    adjustPage();
    emit currentPageChanged(currentPage);
}
