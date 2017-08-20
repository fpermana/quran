#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "database/DbManager.h"
#include "model/PageModel.h"
#include "Settings.h"
#include <QHash>
#include <QStringList>

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int pages READ getPages CONSTANT)
    Q_PROPERTY(PageModel* preview READ getPreview CONSTANT)
    Q_PROPERTY(PageModel* currentPage READ getCurrentPage CONSTANT)
    Q_PROPERTY(SqlQueryModel* indexModel READ getIndexModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* translationModel READ getTranslationModel CONSTANT)
    Q_PROPERTY(SqlQueryModel* activeTranslationModel READ getActiveTranslationModel NOTIFY translationChanged)
    Q_PROPERTY(QString bismillah READ getBismillah  NOTIFY refreshed)
public:
    explicit Controller(QObject *parent = 0);

    void init();
    int getPages() const;

    PageModel *getPreview() const;
    PageModel *getCurrentPage() const;
    Settings *getSettings() const;

    QString getBismillah() const;

    SqlQueryModel *getIndexModel() const;
    SqlQueryModel *getTranslationModel() const;
    SqlQueryModel *getActiveTranslationModel() const;

    Q_INVOKABLE void addBookmark(const int quranTextId);
    Q_INVOKABLE PageModel *getPage(const int page) const;
    Q_INVOKABLE void gatherPage(const int page);
    Q_INVOKABLE void changePage(const int page);
    Q_INVOKABLE void openSura(const int suraId);
    Q_INVOKABLE void downloadTranslation(const QString tid);
    Q_INVOKABLE void removeTranslation(const QString tid);
    Q_INVOKABLE double getYPosition(const int page);
    Q_INVOKABLE double setYPosition(const int page, const double position);

public slots:
    void refresh();

private slots:
    void translationDownloaded();
    void parseTranslation();
    void parsingFinished();

signals:
    void refreshed();
    void pageChanged(const int page);
    void translationChanged();

private:
    void checkDatabase(const bool reset = false);

    DbManager *manager;
//    Downloader *downloader;
    int pages;

    PageModel *firstPage, *midPage, *lastPage, *preview;
    SqlQueryModel *indexModel, *translationModel, *activeTranslationModel;

    QHash<int, PageModel*> pageModelHash;
    Settings *settings;

    QString bismillah;

    QStringList translationList;
};

#endif // CONTROLLER_H
