#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QStringList>
#include <QVariant>
#include "GlobalConstants.h"

class DbManager : public QObject
{
    Q_OBJECT
public:
    explicit DbManager(QObject *parent = 0);
    ~DbManager();

    void init(const QString value);
    bool openDB();
    void closeDB();
    bool checkForUpdate();
    QSqlError lastError();

    QSqlDatabase *getDb() const;

    int getPages();
    QStringList getPage(const int page);
    int openSura(const int sura);
    QVariantMap getJuz(const int sura, const int aya, const QString &textType = DEFAULT_TEXT_TYPE_KEY);
    QVariantMap getSura(const int sura);
    QVariantMap getQuranText(const int sura, const int aya, const QString &textType = DEFAULT_TEXT_TYPE_KEY);
    void addBookmark(const int quranTextId);

    double getYPosition(const int page);
    int setYPosition(const int page, const double position);

    bool installTranslation(const QString &tid);
    bool uninstallTranslation(const QString &tid);
    bool checkTable(const QString &tableName);

    QVariantMap getDbSettings();

signals:
    void queryExecuted();

private:
    QSqlDatabase *db;
    QString filepath;
};

#endif // DBMANAGER_H
