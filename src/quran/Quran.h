#ifndef QURAN_H
#define QURAN_H

#include <QObject>
#include <QSettings>
#include "paging/AyaModel.h"
#include "SuraListModel.h"

class Quran : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int fontSize READ getFontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(QString fontName READ getFontName WRITE setFontName NOTIFY fontNameChanged)
    Q_PROPERTY(QString largeFontName READ getLargeFontName WRITE setLargeFontName NOTIFY largeFontNameChanged)
    Q_PROPERTY(int translationFontSize READ getTranslationFontSize WRITE setTranslationFontSize NOTIFY translationFontSizeChanged)
    Q_PROPERTY(int currentPage READ getCurrentPage WRITE setCurrentPage NOTIFY currentPageChanged)
    Q_PROPERTY(int pageCount READ getPageCount WRITE setPageCount NOTIFY countPageChanged)
    Q_PROPERTY(int currentIndex READ getCurrentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int lastIndex READ getLastIndex WRITE setLastIndex NOTIFY lastIndexChanged)
    Q_PROPERTY(QString quranText READ getQuranText WRITE setQuranText NOTIFY quranTextChanged)
    Q_PROPERTY(QString translation READ getTranslation WRITE setTranslation NOTIFY translationChanged)
    Q_PROPERTY(QString fontColor READ getFontColor WRITE setFontColor NOTIFY fontColorChanged)
    Q_PROPERTY(QString backgroundColor READ getBackgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(bool useBackground READ getUseBackground WRITE setUseBackground NOTIFY useBackgroundChanged)
    Q_PROPERTY(bool useTranslation READ getUseTranslation WRITE setUseTranslation NOTIFY useTranslationChanged)
    Q_PROPERTY(QString translationLocale READ getTranslationLocale WRITE setTranslationLocale NOTIFY translationLocaleChanged)
    Q_PROPERTY(AyaModel* bismillah READ getBismillah NOTIFY bismillahChanged)
    Q_PROPERTY(AyaModel* preview READ getPreview NOTIFY previewChanged)
    Q_PROPERTY(SuraListModel* suraList READ suraList CONSTANT)

public:
    explicit Quran(QObject *parent = nullptr);

    int getFontSize() const;
    QString getFontName() const;
    QString getLargeFontName() const;
    int getTranslationFontSize() const;
    int getCurrentPage() const;
    int getPageCount() const;
    int getCurrentIndex() const;
    int getLastIndex() const;
    QString getQuranText() const;
    QString getTranslation() const;
    QString getFontColor() const;
    QString getBackgroundColor() const;
    bool getUseBackground() const;
    bool getUseTranslation() const;
    QString getTranslationLocale() const;
    AyaModel* getBismillah() const;
    AyaModel* getPreview() const;
    SuraListModel *suraList() const;

signals:
    void fontSizeChanged(int fontSize);
    void fontNameChanged(QString fontName);
    void largeFontNameChanged(QString largeFontName);
    void translationFontSizeChanged(int translationFontSize);
    void currentPageChanged(int currentPage);
    void countPageChanged(int pageCount);
    void currentIndexChanged(int currentIndex);
    void lastIndexChanged(int lastIndex);
    void quranTextChanged(QString quranText);
    void translationChanged(QString translation);
    void fontColorChanged(QString fontColor);
    void backgroundColorChanged(QString backgroundColor);
    void useBackgroundChanged(bool useBackground);
    void useTranslationChanged(bool useTranslation);
    void translationLocaleChanged(QString translationLocale);
    void bismillahChanged();
    void previewChanged();
    void gotoPage(int page);

public slots:
    void setFontSize(int fontSize);
    void setFontName(QString fontName);
    void setLargeFontName(QString largeFontName);
    void setTranslationFontSize(int translationFontSize);
    void setCurrentPage(int currentPage);
    void setPageCount(int pageCount);
    void setCurrentIndex(int currentIndex);
    void setLastIndex(int lastIndex);
    void setQuranText(QString quranText);
    void setTranslation(QString translation);
    void setFontColor(QString fontColor);
    void setBackgroundColor(QString backgroundColor);
    void setUseBackground(bool useBackground);
    void setUseTranslation(bool useTranslation);
    void setTranslationLocale(QString translationLocale);
    void dataReady(const bool status);
    void openSura(const int sura);
    void refreshPreview(QString quranText, QString translation);
    void resetSettings();
    void saveSettings();

private:
    void loadSettings();

    int m_fontSize;
    QString m_fontName;
    QString m_largeFontName;
    int m_translationFontSize;
    int m_currentPage;
    int m_pageCount;
    int m_currentIndex;
    int m_lastIndex;
    QString m_quranText;
    QString m_translation;
    QString m_fontColor;
    QString m_backgroundColor;
    bool m_useBackground;
    bool m_useTranslation;
    QString m_translationLocale;

    QSettings m_settings;

    AyaModel* m_bismillah;
    AyaModel* m_preview;
    SuraListModel* m_suraList;
};

#endif // QURAN_H
