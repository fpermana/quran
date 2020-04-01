#include "Setting.h"
#include "GlobalConstants.h"
#include <QApplication>
#include <QFont>
#include <QFontInfo>
#include <QDebug>

Setting::Setting(QObject *parent) : QSettings(QSettings::IniFormat, QSettings::UserScope, QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION),parent)
{
    loadSetting();
}

void Setting::loadSetting()
{
    beginGroup("UNIVERSAL");
    setUniversalAccent(value(UNIVERSAL_ACCENT_KEY,DEFAULT_UNIVERSAL_ACCENT).toString());
    setUniversalBackground(value(UNIVERSAL_BACKGROUND_KEY,DEFAULT_UNIVERSAL_BACKGROUND).toString());
    setUniversalForeground(value(UNIVERSAL_FOREGROUND_KEY,DEFAULT_UNIVERSAL_FOREGROUND).toString());
    setUniversalTheme(value(UNIVERSAL_THEME_KEY,DEFAULT_UNIVERSAL_THEME).toInt());
    endGroup();

    beginGroup("MATERIAL");
    setMaterialAccent(value(MATERIAL_ACCENT_KEY,DEFAULT_MATERIAL_ACCENT).toString());
    setMaterialBackground(value(MATERIAL_BACKGROUND_KEY,DEFAULT_MATERIAL_BACKGROUND).toString());
    setMaterialForeground(value(MATERIAL_FOREGROUND_KEY,DEFAULT_MATERIAL_FOREGROUND).toString());
    setMaterialTheme(value(MATERIAL_THEME_KEY,DEFAULT_MATERIAL_THEME).toInt());
    setMaterialElevation(value(MATERIAL_ELEVATION_KEY,DEFAULT_MATERIAL_ELEVATION).toInt());
    setMaterialPrimary(value(MATERIAL_PRIMARY_KEY,DEFAULT_MATERIAL_PRIMARY).toString());
    endGroup();

    beginGroup("FONT");
    int pixelSize = qApp->font().pixelSize();
    if(pixelSize == -1) {
        QFontInfo fontInfo(qApp->font());
        pixelSize = fontInfo.pixelSize();
    }
    pixelSize += 4;

    setFontName(value(FONT_NAME_KEY, qApp->font().family()).toString());
    setSmallFontSize(value(SMALL_FONT_SIZE_KEY, pixelSize-4).toInt());
    setFontSize(value(FONT_SIZE_KEY, pixelSize).toInt());
    setLargeFontSize(value(LARGE_FONT_SIZE_KEY, pixelSize+6).toInt());
    endGroup();
}

void Setting::resetSetting()
{
    setUniversalAccent(DEFAULT_UNIVERSAL_ACCENT);
    setUniversalBackground(DEFAULT_UNIVERSAL_BACKGROUND);
    setUniversalForeground(DEFAULT_UNIVERSAL_FOREGROUND);
    setUniversalTheme(DEFAULT_UNIVERSAL_THEME);
    setMaterialAccent(DEFAULT_MATERIAL_ACCENT);
    setMaterialBackground(DEFAULT_MATERIAL_BACKGROUND);
    setMaterialForeground(DEFAULT_MATERIAL_FOREGROUND);
    setMaterialTheme(DEFAULT_MATERIAL_THEME);
    setMaterialElevation(DEFAULT_MATERIAL_ELEVATION);
    setMaterialPrimary(DEFAULT_MATERIAL_PRIMARY);

    setFontName(qApp->font().family());
    setSmallFontSize(qApp->font().pixelSize()-4);
    setFontSize(qApp->font().pixelSize());
    setLargeFontSize(qApp->font().pixelSize()+6);
}

void Setting::saveSetting()
{
    beginGroup("UNIVERSAL");
    setValue(UNIVERSAL_ACCENT_KEY,m_universalAccent);
    setValue(UNIVERSAL_BACKGROUND_KEY,m_universalBackground);
    setValue(UNIVERSAL_FOREGROUND_KEY,m_universalForeground);
    setValue(UNIVERSAL_THEME_KEY,m_universalTheme);
    endGroup();

    beginGroup("MATERIAL");
    setValue(MATERIAL_ACCENT_KEY,m_materialAccent);
    setValue(MATERIAL_BACKGROUND_KEY,m_materialBackground);
    setValue(MATERIAL_FOREGROUND_KEY,m_materialForeground);
    setValue(MATERIAL_THEME_KEY,m_materialTheme);
    setValue(MATERIAL_ELEVATION_KEY,m_materialElevation);
    setValue(MATERIAL_PRIMARY_KEY,m_materialPrimary);
    endGroup();

    beginGroup("FONT");
    setValue(FONT_NAME_KEY, m_fontName);
    setValue(SMALL_FONT_SIZE_KEY, m_smallFontSize);
    setValue(FONT_SIZE_KEY, m_fontSize);
    setValue(LARGE_FONT_SIZE_KEY, m_largeFontSize);
    endGroup();
}

QString Setting::universalAccent() const
{
    return m_universalAccent;
}

void Setting::setUniversalAccent(const QString &universalAccent)
{
    if (m_universalAccent == universalAccent)
        return;

    m_universalAccent = universalAccent;
    emit universalAccentChanged(m_universalAccent);
}

QString Setting::universalBackground() const
{
    return m_universalBackground;
}

void Setting::setUniversalBackground(const QString &universalBackground)
{
    if (m_universalBackground == universalBackground)
        return;

    m_universalBackground = universalBackground;
    emit universalBackgroundChanged(m_universalBackground);
}

QString Setting::universalForeground() const
{
    return m_universalForeground;
}

void Setting::setUniversalForeground(const QString &universalForeground)
{
    if (m_universalForeground == universalForeground)
        return;

    m_universalForeground = universalForeground;
    emit universalForegroundChanged(m_universalForeground);
}

int Setting::universalTheme() const
{
    return m_universalTheme;
}

void Setting::setUniversalTheme(int universalTheme)
{
    if (m_universalTheme == universalTheme)
        return;

    m_universalTheme = universalTheme;
    emit universalThemeChanged(m_universalTheme);
}

QString Setting::materialAccent() const
{
    return m_materialAccent;
}

void Setting::setMaterialAccent(const QString &materialAccent)
{
    if (m_materialAccent == materialAccent)
        return;

    m_materialAccent = materialAccent;
    emit materialAccentChanged(m_materialAccent);
}

QString Setting::materialBackground() const
{
    return m_materialBackground;
}

void Setting::setMaterialBackground(const QString &materialBackground)
{
    if (m_materialBackground == materialBackground)
        return;

    m_materialBackground = materialBackground;
    emit materialBackgroundChanged(m_materialBackground);
}

QString Setting::materialForeground() const
{
    return m_materialForeground;
}

void Setting::setMaterialForeground(const QString &materialForeground)
{
    if (m_materialForeground == materialForeground)
        return;

    m_materialForeground = materialForeground;
    emit materialForegroundChanged(m_materialForeground);
}

int Setting::materialTheme() const
{
    return m_materialTheme;
}

void Setting::setMaterialTheme(int materialTheme)
{
    if (m_materialTheme == materialTheme)
        return;

    m_materialTheme = materialTheme;
    emit materialThemeChanged(m_materialTheme);
}

int Setting::materialElevation() const
{
    return m_materialElevation;
}

void Setting::setMaterialElevation(int materialElevation)
{
    if (m_materialElevation == materialElevation)
        return;

    m_materialElevation = materialElevation;
    emit materialElevationChanged(m_materialElevation);
}

QString Setting::materialPrimary() const
{
    return m_materialPrimary;
}

void Setting::setMaterialPrimary(const QString &materialPrimary)
{
    if (m_materialPrimary == materialPrimary)
        return;

    m_materialPrimary = materialPrimary;
    emit materialPrimaryChanged(m_materialPrimary);
}

int Setting::smallFontSize() const
{
    return m_smallFontSize;
}

void Setting::setSmallFontSize(int smallFontSize)
{
    if (m_smallFontSize == smallFontSize)
        return;

    m_smallFontSize = smallFontSize;
    emit smallFontSizeChanged(m_smallFontSize);
}

int Setting::fontSize() const
{
    return m_fontSize;
}

void Setting::setFontSize(int fontSize)
{
    if (m_fontSize == fontSize)
        return;

    m_fontSize = fontSize;
    emit fontSizeChanged(m_fontSize);
}

int Setting::largeFontSize() const
{
    return m_largeFontSize;
}

void Setting::setLargeFontSize(int largeFontSize)
{
    if (m_largeFontSize == largeFontSize)
        return;

    m_largeFontSize = largeFontSize;
    emit largeFontSizeChanged(m_largeFontSize);
}

QString Setting::fontName() const
{
    return m_fontName;
}

void Setting::setFontName(const QString &fontName)
{
    if (m_fontName == fontName)
        return;

    m_fontName = fontName;
    emit fontNameChanged(m_fontName);
}

void Setting::dataReady(const bool isOk)
{
    if(isOk) {
        loadSetting();
    }
}

