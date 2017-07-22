#include "Settings.h"
#include "GlobalConstants.h"

Settings::Settings(QObject *parent) :
    QSettings(QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION), parent)
{

}

void Settings::restoreSettings()
{
    setCurrentPage(value(CURRENT_PAGE_KEY,1).toInt());
    setFontSize(value(FONT_SIZE_KEY,32).toInt()); // Theme.fontSizeMedium
    setTranslationFontSize(value(TRANSLATION_FONT_SIZE_KEY,25).toInt()); // Theme.fontSizeMedium
    setFontName(value(FONT_NAME_KEY,"Alvi").toString()); // Al_Mushaf.ttf
    setTextType(value(TEXT_TYPE_KEY,DEFAULT_TEXT_TYPE_KEY).toString()); // quran_text_original
    setTranslation(value(TRANSLATION_KEY,DEFAULT_TRANSLATION_KEY).toString()); // indonesia
}

void Settings::resetSettings()
{

}

void Settings::saveSettings()
{
    setValue(TEXT_TYPE_KEY, textType);
    setValue(TRANSLATION_KEY, translation);
    emit settingsChanged();
}

int Settings::getCurrentPage() const
{
    return currentPage;
}

void Settings::setCurrentPage(const int &value)
{
    currentPage = value;
    setValue(CURRENT_PAGE_KEY, currentPage);
    emit currentPageChanged();
}

int Settings::getFontSize() const
{
    return fontSize;
}

void Settings::setFontSize(const int &value)
{
    fontSize = value;
    setValue(FONT_SIZE_KEY, fontSize);
    emit fontSizeChanged();
}

int Settings::getTranslationFontSize() const
{
    return translationFontSize;
}

void Settings::setTranslationFontSize(const int &value)
{
    translationFontSize = value;
    setValue(TRANSLATION_FONT_SIZE_KEY, translationFontSize);
    emit translationFontSizeChanged();
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
    if(translation == value || value.isEmpty())
        return;
    translation = value;
}

QString Settings::getTextType() const
{
    return textType;
}

void Settings::setTextType(const QString &value)
{
    if(textType == value || value.isEmpty())
        return;
    textType = value;
}
