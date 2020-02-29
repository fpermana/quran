#ifndef PAGING_H
#define PAGING_H

#include <QObject>
#include "AyaListModel.h"

class Paging : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int page READ page WRITE setPage NOTIFY pageChanged)
    Q_PROPERTY(QString quranText READ quranText WRITE setQuranText NOTIFY quranTextChanged)
    Q_PROPERTY(QString translation READ translation WRITE setTranslation NOTIFY translationChanged)
    Q_PROPERTY(AyaListModel* ayaList READ ayaList CONSTANT)
public:
    explicit Paging(QObject *parent = nullptr);

    int page() const;
    QString quranText() const;
    QString translation() const;

    AyaListModel* ayaList() const;

public slots:
    void setPage(int page);
    void setQuranText(QString &quranText);
    void setTranslation(QString &translation);

signals:
    void pageChanged(int page);
    void quranTextChanged(QString quranText);
    void translationChanged(QString translation);

private:
    void getAyaList();

    int m_page;
    QString m_quranText;
    QString m_translation;

    AyaListModel *m_ayaList;
};

#endif // PAGING_H
