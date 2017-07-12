#ifndef PAGEMODEL_H
#define PAGEMODEL_H

#include "SqlQueryModel.h"
#include <QSqlDatabase>
#include <QVariantMap>

class PageModel : public SqlQueryModel
{
    Q_OBJECT
    Q_PROPERTY(QString suraEname READ getSuraEname CONSTANT)
    Q_PROPERTY(QString suraName READ getSuraName CONSTANT)
    Q_PROPERTY(int suraId READ getSuraId CONSTANT)
    Q_PROPERTY(QString juzName READ getJuzName CONSTANT)
    Q_PROPERTY(int juzId READ getJuzId CONSTANT)
    Q_PROPERTY(int page READ getPage CONSTANT)
    Q_PROPERTY(QString textType READ getTextType WRITE setTextType)
    Q_PROPERTY(QString translation READ getTranslation WRITE setTranslation)
public:
    explicit PageModel(QObject *parent = 0);
    explicit PageModel(QSqlDatabase *db, QObject *parent = 0);
    void getAya(const int sura1, const int aya1);
    void getAyas(const int sura1, const int aya1);
    void getAyas(const int sura1, const int aya1, const int sura2, const int aya2);

    void setPage(int value);
    int getPage() const;

    void setJuz(const QVariantMap &value);
    void setSura(const QVariantMap &value);

    QString getSuraEname() const;
    QString getSuraName() const;
    int getSuraId() const;

    QString getJuzName() const;
    int getJuzId() const;

    QString getTextType() const;
    void setTextType(const QString &value);

    QString getTranslation() const;
    void setTranslation(const QString &value);

    Q_INVOKABLE void refresh();

signals:

public slots:

private:
    enum ModelType {
        SingleLine = 1,
        NormalPage = 2,
        LastPage = 3
    };

    QSqlDatabase *db;
    int page;
    QVariantMap juz;
    QVariantMap sura;
    QString textType, oldTextType;
    QString translation, oldTranslation;

    int sura1, aya1, sura2, aya2;
    ModelType type;
};

#endif // PAGEMODEL_H
