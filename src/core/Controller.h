#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "database/DbManager.h"
#include "model/PageModel.h"
#include "Settings.h"
#include <QHash>

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int pages READ getPages CONSTANT)
    Q_PROPERTY(int currentPage READ getCurrentPage WRITE setCurrentPage NOTIFY currentPageChanged)
    Q_PROPERTY(PageModel* firstPage READ getFirstPage CONSTANT)
    Q_PROPERTY(PageModel* midPage READ getMidPage CONSTANT)
    Q_PROPERTY(PageModel* lastPage READ getLastPage CONSTANT)
    Q_PROPERTY(PageModel* preview READ getPreview CONSTANT)
    Q_PROPERTY(SqlQueryModel* indexModel READ getIndexModel CONSTANT)
    Q_PROPERTY(QString bismillah READ getBismillah  NOTIFY refreshed)
public:
    explicit Controller(QObject *parent = 0);

    void init();
    int getPages() const;
    int getCurrentPage() const;
    void setCurrentPage(const int page);

    PageModel *getFirstPage() const;
    PageModel *getMidPage() const;
    PageModel *getLastPage() const;
    PageModel *getPreview() const;

    Settings *getSettings() const;

    QString getBismillah() const;

    SqlQueryModel *getIndexModel() const;

    Q_INVOKABLE void bookmark(const int quranTextId);

public slots:
    void refresh();

signals:
    void currentPageChanged(int page);
    void refreshed();

private:
    void checkDatabase(const bool reset = false);
    void adjustPage();

    DbManager *manager;
    int pages, currentPage;

    PageModel *firstPage, *midPage, *lastPage, *preview;
    SqlQueryModel *indexModel;

    QHash<int, PageModel*> pageModelHash;
    Settings *settings;

    QString bismillah;
};

#endif // CONTROLLER_H
