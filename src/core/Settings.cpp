#include "Settings.h"
#include "GlobalConstants.h"
#include <QLocale>

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
    setTranslation(value(TRANSLATION_KEY,DEFAULT_TRANSLATION_KEY).toString()); // id_indonesian
    setTranslationLocale(value(TRANSLATION_LOCALE_KEY,QLocale::system().name()).toString());
    setFontColor(value(FONT_COLOR_KEY,DEFAULT_FONT_COLOR_KEY).toString()); // white
    setBackgroundColor(value(BACKGROUND_COLOR_KEY,DEFAULT_BACKGROUND_COLOR_KEY).toString()); // white
    setUseBackground(value(USE_BACKGROUND_KEY,DEFAULT_USE_BACKGROUND_KEY).toBool()); // 0
    setUseTranslation(value(USE_TRANSLATION_KEY,DEFAULT_USE_TRANSLATION_KEY).toBool()); // 1
}

void Settings::resetSettings()
{

}

void Settings::saveSettings()
{
    setValue(TEXT_TYPE_KEY, textType);
    setValue(TRANSLATION_KEY, translation);
    setValue(TRANSLATION_LOCALE_KEY, translationLocale);
    setValue(FONT_SIZE_KEY,fontSize);
    setValue(TRANSLATION_FONT_SIZE_KEY,translationFontSize);
    setValue(FONT_COLOR_KEY,fontColor);
    setValue(BACKGROUND_COLOR_KEY,backgroundColor);
    setValue(USE_BACKGROUND_KEY,useBackground);
    setValue(USE_TRANSLATION_KEY,useTranslation);
    emit settingsChanged();
}

QString Settings::getTranslationLocale() const
{
    return translationLocale;
}

void Settings::setTranslationLocale(const QString &value)
{
    if(translationLocale == value || value.isEmpty())
        return;
    translationLocale = value;
    emit translationLocaleChanged();
}

bool Settings::getUseTranslation() const
{
    return useTranslation;
}

void Settings::setUseTranslation(bool value)
{
    if(useTranslation == value)
        return;
    useTranslation = value;
    emit useTranslationChanged();
}

bool Settings::getUseBackground() const
{
    return useBackground;
}

void Settings::setUseBackground(bool value)
{
    if(useBackground == value)
        return;
    useBackground = value;
    emit useBackgroundChanged();
}

QString Settings::getFontColor() const
{
    return fontColor;
}

void Settings::setFontColor(const QString &value)
{
    if(fontColor == value || value.isEmpty())
        return;
    fontColor = value;
    emit fontColorChanged();
}

QString Settings::getBackgroundColor() const
{
    return backgroundColor;
}

void Settings::setBackgroundColor(const QString &value)
{
    if(backgroundColor == value || value.isEmpty())
        return;
    backgroundColor = value;
    emit backgroundColorChanged();
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
    if(fontName == value || value.isEmpty())
        return;
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
