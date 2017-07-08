#include "Controller.h"
#include "GlobalFunctions.h"
#include "GlobalConstants.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QStringList>

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::init()
{
    manager = new DbManager(this);
    checkDatabase(true);
    firstPage = new PageModel(manager->getDb(), this);
    midPage = new PageModel(manager->getDb(), this);
    lastPage = new PageModel(manager->getDb(), this);

    currentPage = 10;
    pages = manager->getPages();
    adjustPage();
    emit initialized();
}

void Controller::checkDatabase(const bool reset)
{
    QString filepath = GlobalFunctions::databaseLocation();
    QFile file(filepath);
    if(file.exists() && reset)
        file.remove();

    if(!file.exists()) {
        QFile dbSrc(QString(":/db/%1").arg(DB_NAME));
        QFileInfo fileInfo(filepath);
        QDir dbDir = fileInfo.absoluteDir();
        if(!dbDir.exists())
            dbDir.mkpath(fileInfo.absolutePath());
        dbSrc.copy(filepath);
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
            if(i==currentPage-1)
                model = firstPage;
            else if(i==currentPage)
                model = midPage;
            else if(i==currentPage+1)
                model = lastPage;

            if(model->getPage() != i) {
                pageData = manager->getPage(i);
                if(pageData.count() == 4) {
                    model->setPage(i);
                    model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt(), pageData.at(2).toInt(), pageData.at(3).toInt());
                }
                else if(pageData.count() == 2) {
                    model->setPage(i);
                    model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt());
                }
            }
        }
    }
}

PageModel *Controller::getLastPage() const
{
    return lastPage;
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

int Controller::setCurrentPage(const int page)
{
    currentPage = page;
    adjustPage();
    emit currentPageChanged();
}
