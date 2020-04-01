#ifndef SETTING_H
#define SETTING_H

#include <QSettings>

class Setting : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(int smallFontSize READ smallFontSize WRITE setSmallFontSize NOTIFY smallFontSizeChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(int largeFontSize READ largeFontSize WRITE setLargeFontSize NOTIFY largeFontSizeChanged)
    Q_PROPERTY(QString fontName READ fontName WRITE setFontName NOTIFY fontNameChanged)
    Q_PROPERTY(QString universalAccent READ universalAccent WRITE setUniversalAccent NOTIFY universalAccentChanged)
    Q_PROPERTY(QString universalBackground READ universalBackground WRITE setUniversalBackground NOTIFY universalBackgroundChanged)
    Q_PROPERTY(QString universalForeground READ universalForeground WRITE setUniversalForeground NOTIFY universalForegroundChanged)
    Q_PROPERTY(int universalTheme READ universalTheme WRITE setUniversalTheme NOTIFY universalThemeChanged)
    Q_PROPERTY(QString materialAccent READ materialAccent WRITE setMaterialAccent NOTIFY materialAccentChanged)
    Q_PROPERTY(QString materialBackground READ materialBackground WRITE setMaterialBackground NOTIFY materialBackgroundChanged)
    Q_PROPERTY(QString materialForeground READ materialForeground WRITE setMaterialForeground NOTIFY materialForegroundChanged)
    Q_PROPERTY(int materialTheme READ materialTheme WRITE setMaterialTheme NOTIFY materialThemeChanged)
    Q_PROPERTY(int materialElevation READ materialElevation WRITE setMaterialElevation NOTIFY materialElevationChanged)
    Q_PROPERTY(QString materialPrimary READ materialPrimary WRITE setMaterialPrimary NOTIFY materialPrimaryChanged)

public:
    explicit Setting(QObject *parent = nullptr);

    void loadSetting();

    QString universalAccent() const;
    void setUniversalAccent(const QString &universalAccent);

    QString universalBackground() const;
    void setUniversalBackground(const QString &universalBackground);

    QString universalForeground() const;
    void setUniversalForeground(const QString &universalForeground);

    int universalTheme() const;
    void setUniversalTheme(int universalTheme);

    QString materialAccent() const;
    void setMaterialAccent(const QString &materialAccent);

    QString materialBackground() const;
    void setMaterialBackground(const QString &materialBackground);

    QString materialForeground() const;
    void setMaterialForeground(const QString &materialForeground);

    int materialTheme() const;
    void setMaterialTheme(int materialTheme);

    int materialElevation() const;
    void setMaterialElevation(int materialElevation);

    QString materialPrimary() const;
    void setMaterialPrimary(const QString &materialPrimary);

    int smallFontSize() const;
    void setSmallFontSize(int smallFontSize);

    int fontSize() const;
    void setFontSize(int fontSize);

    void setLargeFontSize(int largeFontSize);
    int largeFontSize() const;

    QString fontName() const;
    void setFontName(const QString &fontName);

public slots:
    void dataReady(const bool isOk);
    void resetSetting();
    void saveSetting();

signals:
    void universalAccentChanged(QString universalAccent);
    void universalBackgroundChanged(QString universalBackground);
    void universalForegroundChanged(QString universalForeground);
    void universalThemeChanged(int universalTheme);
    void materialAccentChanged(QString materialAccent);
    void materialBackgroundChanged(QString materialBackground);
    void materialForegroundChanged(QString materialForeground);
    void materialThemeChanged(int materialTheme);
    void materialElevationChanged(int materialElevation);
    void materialPrimaryChanged(QString materialPrimary);

    void smallFontSizeChanged(int smallFontSize);
    void fontSizeChanged(int fontSize);
    void largeFontSizeChanged(int largeFontSize);
    void fontNameChanged(QString fontName);

private:
    // Universal
    QString m_universalAccent;
    QString m_universalBackground;
    QString m_universalForeground;
    int m_universalTheme;
    // Material
    QString m_materialAccent;
    QString m_materialBackground;
    QString m_materialForeground;
    int m_materialTheme;
    int m_materialElevation;
    QString m_materialPrimary;

    int m_smallFontSize;
    int m_fontSize;
    int m_largeFontSize;
    QString m_fontName;
};

#endif // SETTING_H
