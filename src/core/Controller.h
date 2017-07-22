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
    Q_PROPERTY(PageModel* preview READ getPreview CONSTANT)
    Q_PROPERTY(PageModel* currentPage READ getCurrentPage CONSTANT)
    Q_PROPERTY(SqlQueryModel* indexModel READ getIndexModel CONSTANT)
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

    Q_INVOKABLE void addBookmark(const int quranTextId);
    Q_INVOKABLE PageModel *getPage(const int page) const;
    Q_INVOKABLE void gatherPage(const int page);
    Q_INVOKABLE void changePage(const int page);

public slots:
    void refresh();

signals:
    void refreshed();

private:
    void checkDatabase(const bool reset = false);

    DbManager *manager;
    int pages;

    PageModel *firstPage, *midPage, *lastPage, *preview;
    SqlQueryModel *indexModel;

    QHash<int, PageModel*> pageModelHash;
    Settings *settings;

    QString bismillah;
};

#endif // CONTROLLER_H
