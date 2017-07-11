#include "Settings.h"
#include "GlobalConstants.h"

#define CURRENT_PAGE_KEY        "current_page"
#define FONT_SIZE_KEY           "font_size"
#define FONT_NAME_KEY           "font_name"
#define TEXT_TYPE_KEY           "text_type"
#define TRANSLATION_KEY         "translation"

Settings::Settings(QObject *parent) :
    QSettings(QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION), parent)
{

}

void Settings::restoreSettings()
{
    setCurrentPage(value(CURRENT_PAGE_KEY,1).toInt());
    setFontSize(value(FONT_SIZE_KEY,32).toInt()); // Theme.fontSizeMedium
    setFontName(value(FONT_NAME_KEY,"Alvi").toString()); // Al_Mushaf.ttf
    setTextType(value(TEXT_TYPE_KEY,"quran_text").toString()); // quran_text
    setTranslation(value(TRANSLATION_KEY,"id_indonesian").toString()); // indonesia
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
    setValue(CURRENT_PAGE_KEY, currentPage);
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

QString Settings::getTranslation() const
{
    return translation;
}

void Settings::setFontName(const QString &value)
{
    fontName = value;
}

void Settings::setTranslation(const QString &value)
{
    translation = value;
}

QString Settings::getTextType() const
{
    return textType;
}

void Settings::setTextType(const QString &value)
{
    textType = value;
}
