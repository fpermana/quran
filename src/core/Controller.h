#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "database/DbManager.h"

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = 0);

    void init();

signals:

public slots:

private:
    void checkDatabase(const bool reset = false);

    DbManager *manager;
};

#endif // CONTROLLER_H
