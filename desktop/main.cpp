//#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <singleapplication.h>
#include "sqlite/DbManager.h"
#include "quran/Quran.h"
#include "paging/Paging.h"
#include "searching/Searching.h"
#include "translation/Translation.h"
#include "bookmarking/Bookmarking.h"
#include "setting/Setting.h"
#include "GlobalConstants.h"
#include <QQuickStyle>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName(SETTINGS_ORGANIZATION);
    QCoreApplication::setOrganizationDomain(SETTINGS_DOMAIN);
    QCoreApplication::setApplicationName(SETTINGS_APPLICATION);

//    QGuiApplication app(argc, argv);
    SingleApplication app( argc, argv );

    QQuickStyle::setStyle("Universal");

    DbManager man;
    Quran quran;
    Translation translation;
    Searching searching;
    Bookmarking bookmarking;
    Setting setting;
    QObject::connect(&man, SIGNAL(dataReady(bool)), &bookmarking, SLOT(dataReady(bool)),Qt::QueuedConnection);
    QObject::connect(&man, SIGNAL(dataReady(bool)), &quran, SLOT(dataReady(bool)),Qt::QueuedConnection);
    QObject::connect(&man, SIGNAL(dataReady(bool)), &translation, SLOT(dataReady(bool)),Qt::QueuedConnection);

    qmlRegisterType<Paging>("id.fpermana.sailquran", 1, 0, "Paging");
    qmlRegisterType<AyaListModel>("id.fpermana.sailquran", 1, 0, "AyaList");
    qmlRegisterType<AyaModel>("id.fpermana.sailquran", 1, 0, "AyaModel");
    qmlRegisterType<TranslationListModel>("id.fpermana.sailquran", 1, 0, "TranslationList");
    qmlRegisterType<TranslationModel>("id.fpermana.sailquran", 1, 0, "TranslationModel");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("Quran", &quran);
    rootContext->setContextProperty("Translation", &translation);
    rootContext->setContextProperty("Searching", &searching);
    rootContext->setContextProperty("Bookmarking", &bookmarking);
    rootContext->setContextProperty("Setting", &setting);

    engine.load(url);

    man.openDB();

    return app.exec();
}
