#ifndef PAGEMANAGER_H
#define PAGEMANAGER_H

#include <QObject>
#include "paging/AyaModel.h"

class PageManager : public QObject
{
    Q_OBJECT
public:
    explicit PageManager(QString quranText, QString translation, QObject *parent = nullptr);

    QString getQuranText() const;
    void setQuranText(const QString &value);

    QString getTranslation() const;
    void setTranslation(const QString &translation);

    QPair<int,int> getSuraAyaStart(const int pageNumber) const;
    int getIdBySuraAya(const int suraNumber, const int ayaNumber) const;
    AyaModel* getAya(const int id);
    QList<AyaModel*> getAyaListFrom(const int id);
    QList<AyaModel*> getAyaListBetween(const int firstId, const int secondId, const bool inclusive = false);

signals:

public slots:

private:
    QString m_quranText;
    QString m_translation;
};

#endif // PAGEMANAGER_H
