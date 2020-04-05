#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QObject>
#include <QVariantMap>
#include "TranslationModel.h"
#include "TranslationListModel.h"

class Translation : public QObject
{
    Q_OBJECT
    Q_ENUMS(Status)
public:
    explicit Translation(QObject *parent = nullptr);

    enum Status {
        Removed = -1,
        NotInstalled,
        Queued,
        Downloading,
        Installing,
        Installed
    };

signals:
    void activeTranslationLoaded(TranslationListModel *translation);
    void translationLoaded(TranslationListModel *translation);
    void translationInstalled(QString tid);
    void translationUninstalled(QString tid);

public slots:
    void installTranslation(QString tid);
    void uninstallTranslation(QString tid);
    void dataReady(const bool status);

    void getActiveTranslation();
    void getAllTranslation();

    int getStatus(const QString tid) const;

private slots:
    void translationDownloaded();
    void translationParsed();

private:
    void downloadTranslation(QString tid);
    void parseTranslation(QString tid);
    void processNextQueue();

    QVariantMap m_downloadMap;
};

#endif // TRANSLATION_H
