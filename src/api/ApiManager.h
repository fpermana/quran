#ifndef APIMANAGER_H
#define APIMANAGER_H

#include <QObject>
#include <QStringList>
#include <QVariant>

#ifndef DEFAULT_CONNECTION_NAME
#define DEFAULT_CONNECTION_NAME     "sailquran"
#endif

class ApiManager : public QObject
{
    Q_OBJECT
public:
    explicit ApiManager(QObject *parent = nullptr);
    ~ApiManager();

//    void init(const QString value);
    void openDB();
    void closeDB();
    bool checkForUpdate();

    /*int getPages();
    QStringList getPage(const int page);
    int openSura(const int sura);
    QVariantMap getJuz(const int sura, const int aya, const QString &textType = DEFAULT_TEXT_TYPE_KEY);
    QVariantMap getSura(const int sura);
    QVariantMap getQuranText(const int sura, const int aya, const QString &textType = DEFAULT_TEXT_TYPE_KEY);
    void toogleBookmark(const int quranTextId);
    void addBookmark(const int quranTextId);
    void removeBookmark(const int quranTextId);

    double getYPosition(const int page);
    int setYPosition(const int page, const double position);

    bool installTranslation(const QString &tid);
    bool uninstallTranslation(const QString &tid);
    bool checkTable(const QString &tableName);

    QVariantMap getDbSettings();
*/
signals:
//    void queryExecuted();
    void dataReady(const bool status);
private slots:
    void dbExtracted(const bool isOk);

private:
    QString filepath;

    void checkDatabase();
    void prepareDatabase();
    bool tableExist(const QString tableName);
    QVariantMap getDbSettings();
};

#endif // APIMANAGER_H
