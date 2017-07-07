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

void Controller::nextPage()
{
    qDebug() << __FUNCTION__;
    currentPage++;
    adjustPage();
}

void Controller::previosPage()
{
    qDebug() << __FUNCTION__;
    currentPage--;
    adjustPage();
}

void Controller::gotoPage(const int page)
{
    currentPage = page;
    adjustPage();
}

PageModel *Controller::getPageModel(const int page)
{
    return pageModelHash.value(page);
}

void Controller::init()
{
    manager = new DbManager(this);
    checkDatabase(true);
    firstPage = new PageModel(manager->getDb());
    midPage = new PageModel(manager->getDb());
    lastPage = new PageModel(manager->getDb());

    currentPage = 10;
    pages = manager->getPages();
    adjustPage();
    /*QStringList pageList;
    if(currentPage == 1) {
        pageList.append("1");
        pageList.append("2");
        pageList.append("3");
    }
    else if(currentPage == pages) {
        pageList.append(QString(pages-2));
        pageList.append(QString(pages-1));
        pageList.append(QString(pages));
    }
    else {
        pageList.append(QString(currentPage-1));
        pageList.append(QString(currentPage));
        pageList.append(QString(currentPage+1));
    }

    PageModel *model;
    QStringList pageData;
    for (int i = 0; i < 3; i++) {
        pageData = manager->getPage(pageList.at(i).toInt());
        if(i==0)
            model = firstPage;
        else if(i==1)
            model = midPage;
        else if(i==2)
            model = lastPage;
        model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt(), pageData.at(2).toInt(), pageData.at(3).toInt());
    }*/
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
//    QStringList pageData = manager->getPage(currentPage);
//    int sura1 = pageData.at(0).toInt();
    //    emit pagesChanged();
}

void Controller::adjustPage()
{
    PageModel *model;
    QStringList pageData;
    for(int i=(currentPage-1); i<=(currentPage+1); i++) {
        if(pageModelHash.contains(i))
            continue;

        if(i>=1 && i<=pages) {
            /*if(i%3==0)
                model = lastPage;
            else if(i%3==1)
                model = firstPage;
            else if(i%3==2)
                model = midPage;*/

            model = new PageModel(manager->getDb());

            if(model->getPage() != i) {
                pageData = manager->getPage(i);
                qDebug() << "NOT SAME" << model->getPage() << i;
                model->setPage(i);
                model->getAyas(pageData.at(0).toInt(), pageData.at(1).toInt(), pageData.at(2).toInt(), pageData.at(3).toInt());

                pageModelHash.insert(i, model);
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
