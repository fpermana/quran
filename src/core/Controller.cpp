#include "Controller.h"
#include "GlobalFunctions.h"
#include "GlobalConstants.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QFileInfo>

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::init()
{
    manager = new DbManager(this);
    checkDatabase(true);
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
    qDebug() << manager->getPages();
}
