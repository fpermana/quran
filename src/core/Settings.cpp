#include "Settings.h"
#include "GlobalConstants.h"

#define CURRENT_PAGE_KEY        "current_page"
#define FONT_SIZE_KEY           "font_size"
#define FONT_NAME_KEY           "font_name"

Settings::Settings(QObject *parent) :
    QSettings(QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION), parent)
{

}

void Settings::restoreSettings()
{
    setCurrentPage(value(CURRENT_PAGE_KEY,1).toInt());
    setFontSize(value(FONT_SIZE_KEY,32).toInt()); // Theme.fontSizeMedium
    setFontName(value(FONT_NAME_KEY,"Lateef").toString()); // LateefRegOT.ttf
}

void Settings::saveSettings()
{

}

int Settings::getCurrentPage() const
{
    return currentPage;
}

void Settings::setCurrentPage(const int &value)
{
    currentPage = value;
}

int Settings::getFontSize() const
{
    return fontSize;
}

void Settings::setFontSize(const int &value)
{
    fontSize = value;
}

QString Settings::getFontName() const
{
    return fontName;
}

void Settings::setFontName(const QString &value)
{
    fontName = value;
}
