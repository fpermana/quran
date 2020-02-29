#ifndef AYAMODEL_H
#define AYAMODEL_H

#include <QObject>

class AyaModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString translation READ translation WRITE setTranslation NOTIFY translationChanged)
    Q_PROPERTY(int sura READ sura WRITE setSura NOTIFY suraChanged)
    Q_PROPERTY(int aya READ aya WRITE setAya NOTIFY ayaChanged)
    Q_PROPERTY(QString suraName READ suraName WRITE setSuraName NOTIFY suraNameChanged)
    Q_PROPERTY(bool marked READ marked WRITE setMarked NOTIFY markedChanged)
public:
    explicit AyaModel(QObject *parent = nullptr);

    int number() const;
    QString text() const;
    QString translation() const;
    int sura() const;
    int aya() const;
    QString suraName() const;
    bool marked() const;

signals:
    void numberChanged(int number);
    void textChanged(QString text);
    void translationChanged(QString translation);
    void suraChanged(int sura);
    void ayaChanged(int aya);
    void suraNameChanged(QString suraName);
    void markedChanged(bool marked);

public slots:
    void setNumber(int number);
    void setText(QString text);
    void setTranslation(QString translation);
    void setSura(int sura);
    void setAya(int aya);
    void setSuraName(QString suraName);
    void setMarked(bool marked);

private:
    int m_number;
    QString m_text;
    QString m_translation;
    int m_sura;
    int m_aya;
    QString m_suraName;
    bool m_marked;
};

#endif // AYAMODEL_H
