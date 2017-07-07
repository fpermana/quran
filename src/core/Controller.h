#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "database/DbManager.h"
#include "model/PageModel.h"
#include <QHash>

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int pages READ getPages CONSTANT)
    Q_PROPERTY(int currentPage READ getCurrentPage CONSTANT)
    Q_PROPERTY(PageModel* firstPage READ getFirstPage CONSTANT)
    Q_PROPERTY(PageModel* midPage READ getMidPage CONSTANT)
    Q_PROPERTY(PageModel* lastPage READ getLastPage CONSTANT)
public:
    explicit Controller(QObject *parent = 0);

    Q_INVOKABLE void nextPage();
    Q_INVOKABLE void previosPage();
    Q_INVOKABLE void gotoPage(const int page);
    Q_INVOKABLE PageModel *getPageModel(const int page);

    void init();
    int getPages() const;
    int getCurrentPage() const;

    PageModel *getFirstPage() const;
    PageModel *getMidPage() const;
    PageModel *getLastPage() const;

signals:
    void initialized();

public slots:

private:
    void checkDatabase(const bool reset = false);
    void adjustPage();

    DbManager *manager;
    int pages, currentPage;

    PageModel *firstPage, *midPage, *lastPage;

    QHash<int, PageModel*> pageModelHash;
};

#endif // CONTROLLER_H
