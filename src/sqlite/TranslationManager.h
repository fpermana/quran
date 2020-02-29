#ifndef TRANSLATIONMANAGER_H
#define TRANSLATIONMANAGER_H

#include <QObject>
#include <QList>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include "translation/TranslationModel.h"

class TranslationManager : public QObject
{
    Q_OBJECT
public:
    explicit TranslationManager(bool threaded = false, QObject *parent = nullptr);
    ~TranslationManager();

    QList<TranslationModel *> getAllTranslation();
    QList<TranslationModel *> getInstalledTranslation();
    bool tableExist(const QString tableName);
    int rowCount(const QString tableName);
    bool installTranslation(const QString &tid);
    bool uninstallTranslation(const QString &tid);

    bool createTranslationTable(const QString &tableName);

    bool insertTranslationList(const QString &tableName, QStringList idList, QStringList suraList, QStringList ayaList, QStringList textList);
signals:

public slots:

private:
    QSqlDatabase createDb();

    bool m_threaded;
};

#endif // TRANSLATIONMANAGER_H
