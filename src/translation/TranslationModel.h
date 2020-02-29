#ifndef TRANSLATIONMODEL_H
#define TRANSLATIONMODEL_H

#include <QObject>

class TranslationModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(QString flag READ flag WRITE setFlag NOTIFY flagChanged)
    Q_PROPERTY(QString lang READ lang WRITE setLang NOTIFY langChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString translator READ translator WRITE setTranslator NOTIFY translatorChanged)
    Q_PROPERTY(QString tid READ tid WRITE setTid NOTIFY tidChanged)
    Q_PROPERTY(bool installed READ installed WRITE setInstalled NOTIFY installedChanged)
    Q_PROPERTY(bool isDefault READ isDefault WRITE setIsDefault NOTIFY isDefaultChanged)
    Q_PROPERTY(bool visible READ visible WRITE setVisible NOTIFY visibleChanged)
    Q_PROPERTY(QString iso6391 READ iso6391 WRITE setIso6391 NOTIFY iso6391Changed)
public:
    explicit TranslationModel(QObject *parent = nullptr);

    int number() const;
    QString flag() const;
    QString lang() const;
    QString name() const;
    QString translator() const;
    QString tid() const;
    bool installed() const;
    bool isDefault() const;
    bool visible() const;
    QString iso6391() const;

signals:
    void numberChanged(int number);
    void flagChanged(QString flag);
    void langChanged(QString lang);
    void nameChanged(QString name);
    void translatorChanged(QString translator);
    void tidChanged(QString tid);
    void installedChanged(bool installed);
    void isDefaultChanged(bool isDefault);
    void visibleChanged(bool visible);
    void iso6391Changed(QString iso6391);

public slots:
    void setNumber(int number);
    void setFlag(QString flag);
    void setLang(QString lang);
    void setName(QString name);
    void setTranslator(QString translator);
    void setTid(QString tid);
    void setInstalled(bool installed);
    void setIsDefault(bool isDefault);
    void setVisible(bool visible);
    void setIso6391(QString iso6391);

private:
    int m_number;
    QString m_flag;
    QString m_lang;
    QString m_name;
    QString m_translator;
    QString m_tid;
    bool m_installed;
    bool m_is_default;
    bool m_visible;
    QString m_iso6391;
};

#endif // TRANSLATIONMODEL_H
