#include "Quran.h"
#include <QDebug>

#ifdef USE_API
#include "api/QuranManager.h"
#else
#include "sqlite/QuranManager.h"
#endif
#include "GlobalConstants.h"

Quran::Quran(QObject *parent) :
    QObject(parent), m_currentPage(1), m_quranText(""), m_translation(""), m_settings(QSettings::IniFormat, QSettings::UserScope, QString(SETTINGS_ORGANIZATION), QString(SETTINGS_APPLICATION)), m_bismillah(nullptr), m_preview(nullptr)
{
    loadSettings();
}

int Quran::getFontSize() const
{
    return m_fontSize;
}

QString Quran::getFontName() const
{
    return m_fontName;
}

QString Quran::getLargeFontName() const
{
    return m_fontName;
}

int Quran::getTranslationFontSize() const
{
    return m_translationFontSize;
}

int Quran::getCurrentPage() const
{
    return m_currentPage;
}

int Quran::getPageCount() const
{
    return m_pageCount;
}

int Quran::getCurrentIndex() const
{
    return m_currentIndex;
}

int Quran::getLastIndex() const
{
    return m_lastIndex;
}

QString Quran::getQuranText() const
{
    return m_quranText;
}

QString Quran::getTranslation() const
{
    return m_translation;
}

QString Quran::getFontColor() const
{
    return m_fontColor;
}

QString Quran::getBackgroundColor() const
{
    return m_backgroundColor;
}

bool Quran::getUseBackground() const
{
    return m_useBackground;
}

bool Quran::getUseTranslation() const
{
    return m_useTranslation;
}

QString Quran::getTranslationLocale() const
{
    return m_translationLocale;
}

AyaModel *Quran::getBismillah() const
{
    return m_bismillah;
}

AyaModel *Quran::getPreview() const
{
    return m_preview;
}

SuraListModel *Quran::suraList() const
{
    return m_suraList;
}

void Quran::setFontSize(int fontSize)
{
    if (m_fontSize == fontSize)
        return;

    m_fontSize = fontSize;
    emit fontSizeChanged(m_fontSize);
}

void Quran::setFontName(QString fontName)
{
    if (m_fontName == fontName)
        return;

    m_fontName = fontName;
    emit fontNameChanged(m_fontName);
}

void Quran::setLargeFontName(QString largeFontName)
{
    if (m_largeFontName == largeFontName)
        return;

    m_largeFontName = largeFontName;
    emit fontNameChanged(m_largeFontName);
}

void Quran::setTranslationFontSize(int translationFontSize)
{
    if (m_translationFontSize == translationFontSize)
        return;

    m_translationFontSize = translationFontSize;
    emit translationFontSizeChanged(m_translationFontSize);
}

void Quran::setCurrentPage(int currentPage)
{
    if (m_currentPage == currentPage)
        return;

    m_currentPage = currentPage;
    m_settings.setValue(CURRENT_PAGE_KEY, m_currentPage);
    emit currentPageChanged(m_currentPage);
}

void Quran::setPageCount(int pageCount)
{
    if (m_pageCount == pageCount)
        return;

    m_pageCount = pageCount;
    emit countPageChanged(m_pageCount);
}

void Quran::setCurrentIndex(int currentIndex)
{
    if (m_currentIndex == currentIndex)
        return;

    m_currentIndex = currentIndex;
    m_settings.setValue(CURRENT_INDEX_KEY, m_currentIndex);
    emit currentIndexChanged(m_currentIndex);
}

void Quran::setLastIndex(int lastIndex)
{
    if (m_lastIndex == lastIndex)
        return;

    m_lastIndex = lastIndex;
    m_settings.setValue(LAST_INDEX_KEY, m_lastIndex);
    emit lastIndexChanged(m_lastIndex);
}

void Quran::setQuranText(QString quranText)
{
    if (m_quranText == quranText)
        return;

    m_quranText = quranText;
    refreshPreview(m_quranText,m_translation);
    emit quranTextChanged(m_quranText);
}

void Quran::setTranslation(QString translation)
{
    if (m_translation == translation)
        return;

    m_translation = translation;
    refreshPreview(m_quranText,m_translation);
    emit translationChanged(m_translation);
}

void Quran::setFontColor(QString fontColor)
{
    if (m_fontColor == fontColor)
        return;

    m_fontColor = fontColor;
    emit fontColorChanged(m_fontColor);
}

void Quran::setBackgroundColor(QString backgroundColor)
{
    if (m_backgroundColor == backgroundColor)
        return;

    m_backgroundColor = backgroundColor;
    emit backgroundColorChanged(m_backgroundColor);
}

void Quran::setUseBackground(bool useBackground)
{
    if (m_useBackground == useBackground)
        return;

    m_useBackground = useBackground;
    emit useBackgroundChanged(m_useBackground);
}

void Quran::setUseTranslation(bool useTranslation)
{
    if (m_useTranslation == useTranslation)
        return;

    m_useTranslation = useTranslation;
    emit useTranslationChanged(m_useTranslation);
}

void Quran::setTranslationLocale(QString translationLocale)
{
    if (m_translationLocale == translationLocale)
        return;

    m_translationLocale = translationLocale;
    emit translationLocaleChanged(m_translationLocale);
}

void Quran::dataReady(const bool status)
{
    if(status) {
        QuranManager *q = new QuranManager;
        setPageCount(q->pageCount());

        int currentPage = m_settings.value(CURRENT_PAGE_KEY, 1).toInt();
//        qDebug() << m_settings.fileName();
        setCurrentPage(currentPage);
        emit gotoPage(currentPage);

        m_bismillah = q->getBismillah(m_quranText, m_translation);
        emit bismillahChanged();

        m_preview = q->getAya(2,2,m_quranText,m_translation);
        emit previewChanged();

        m_suraList = new SuraListModel(this);
        m_suraList->setSuraList(q->getSuraList());

        q->deleteLater();
    }
}

void Quran::openSura(const int sura)
{
    if(sura<1) {
        return;
    }

    QuranManager *q = new QuranManager;
    QVariantMap pageMap = q->getSuraPage(sura);
    int page = pageMap.value("page",0).toInt();
    int aSura = pageMap.value("sura",0).toInt();
    int aya = pageMap.value("aya",0).toInt();

    if(aSura == sura && aya > 1) {
        page--;
    }
    setCurrentPage(page);
    emit gotoPage(page);
}

void Quran::refreshPreview(QString quranText, QString translation)
{
    QuranManager *q = new QuranManager;
    m_preview = q->getAya(2,2,quranText,translation);
    emit previewChanged();
    q->deleteLater();
}

void Quran::resetSettings()
{
    setQuranText(DEFAULT_QURAN_TEXT);
    setTranslation(DEFAULT_TRANSLATION);
    setFontName(DEFAULT_FONT_NAME);
    setLargeFontName(DEFAULT_LARGE_FONT_NAME);
    setFontColor(DEFAULT_FONT_COLOR);
    setFontSize(DEFAULT_FONT_SIZE);
    setTranslationFontSize(DEFAULT_TRANSLATION_FONT_SIZE);
    setBackgroundColor(DEFAULT_BACKGROUND_COLOR);
    setUseBackground(DEFAULT_USE_BACKGROUND);
    setUseTranslation(DEFAULT_USE_TRANSLATION);
    saveSettings();
}

void Quran::saveSettings()
{
    m_settings.setValue(QURAN_TEXT_KEY, m_quranText);
    m_settings.setValue(TRANSLATION_KEY, m_translation);
    m_settings.setValue(FONT_NAME_KEY, m_fontName);
    m_settings.setValue(LARGE_FONT_NAME_KEY, m_largeFontName);
    m_settings.setValue(FONT_COLOR_KEY, m_fontColor);
    m_settings.setValue(FONT_SIZE_KEY, m_fontSize);
    m_settings.setValue(TRANSLATION_FONT_SIZE_KEY, m_translationFontSize);
    m_settings.setValue(BACKGROUND_COLOR_KEY, m_backgroundColor);
    m_settings.setValue(USE_BACKGROUND_KEY, m_useBackground);
    m_settings.setValue(USE_TRANSLATION_KEY, m_useTranslation);
}

void Quran::loadSettings()
{
    QString quranText = m_settings.value(QURAN_TEXT_KEY, DEFAULT_QURAN_TEXT).toString();
    setQuranText(quranText);
    QString translation = m_settings.value(TRANSLATION_KEY, DEFAULT_TRANSLATION).toString();
    setTranslation(translation);
    QString fontName = m_settings.value(FONT_NAME_KEY, DEFAULT_FONT_NAME).toString();
    setFontName(fontName);
    QString largeFontName = m_settings.value(LARGE_FONT_NAME_KEY, DEFAULT_LARGE_FONT_NAME).toString();
    setLargeFontName(largeFontName);
    QString fontColor = m_settings.value(FONT_COLOR_KEY, DEFAULT_FONT_COLOR).toString();
    setFontColor(fontColor);
    int fontSize = m_settings.value(FONT_SIZE_KEY, DEFAULT_FONT_SIZE).toInt();
    setFontSize(fontSize);
    int translationFontSize = m_settings.value(TRANSLATION_FONT_SIZE_KEY, DEFAULT_TRANSLATION_FONT_SIZE).toInt();
    setTranslationFontSize(translationFontSize);
    QString backgroundColor = m_settings.value(BACKGROUND_COLOR_KEY,DEFAULT_BACKGROUND_COLOR).toString();
    setBackgroundColor(backgroundColor);
    bool useBackground = m_settings.value(USE_BACKGROUND_KEY,DEFAULT_USE_BACKGROUND).toBool();
    setUseBackground(useBackground);
    bool useTranslation = m_settings.value(USE_TRANSLATION_KEY,DEFAULT_USE_TRANSLATION).toBool();
    setUseTranslation(useTranslation);
    int currentIndex = m_settings.value(CURRENT_INDEX_KEY, 0).toInt();
    setCurrentIndex(currentIndex);
    int lastIndex = m_settings.value(LAST_INDEX_KEY, 0).toInt();
    setLastIndex(lastIndex);

//    qDebug() << m_quranText << m_translation << m_fontColor << m_backgroundColor << m_useBackground << m_useTranslation;
}
