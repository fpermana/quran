#include "Settings.h"
#include "GlobalConstants.h"

#define CURRENT_PAGE_KEY        "current_page"

Settings::Settings(QObject *parent) :
    QSettings(QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION), parent)
{

}

void Settings::restoreSettings()
{
    setCurrentPage(value(CURRENT_PAGE_KEY,1).toInt());
}

void Settings::saveSettings()
{

}

int Settings::getCurrentPage() const
{
    return currentPage;
}

void Settings::setCurrentPage(int value)
{
    currentPage = value;
}
