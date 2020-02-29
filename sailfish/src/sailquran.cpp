#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <QGuiApplication>

#include "sqlite/DbManager.h"
#include "paging/Paging.h"
#include "searching/Searching.h"
#include "bookmarking/Bookmarking.h"
#include "translation/Translation.h"
#include "quran/Quran.h"
#include "GlobalConstants.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName(SETTINGS_ORGANIZATION);
    QCoreApplication::setOrganizationDomain(SETTINGS_DOMAIN);
    QCoreApplication::setApplicationName(SETTINGS_APPLICATION);

    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    DbManager man;
    Quran quran;
    Bookmarking bookmarking;
    Searching searching;
    Translation translation;
    QObject::connect(&man, SIGNAL(dataReady(bool)), &bookmarking, SLOT(dataReady(bool)),Qt::QueuedConnection);
    QObject::connect(&man, SIGNAL(dataReady(bool)), &quran, SLOT(dataReady(bool)),Qt::QueuedConnection);
//    QObject::connect(&man, SIGNAL(dataReady(bool)), &translation, SLOT(dataReady(bool)),Qt::QueuedConnection);

    qmlRegisterType<Paging>("id.fpermana.sailquran", 1, 0, "Paging");
    qmlRegisterType<AyaListModel>("id.fpermana.sailquran", 1, 0, "AyaList");
    qmlRegisterType<AyaModel>("id.fpermana.sailquran", 1, 0, "AyaModel");
    qmlRegisterType<TranslationListModel>("id.fpermana.sailquran", 1, 0, "TranslationList");
    qmlRegisterType<TranslationModel>("id.fpermana.sailquran", 1, 0, "TranslationModel");
//    qmlRegisterType<Translation::Status>("id.fpermana.sailquran", 1, 0, "TranslationStatus");
//    qmlRegisterUncreatableType<Translation::Status>("id.fpermana.sailquran", 1, 0, "TranslationStatus", "Not creatable as it is an enum type.");
//    qmlRegisterType<PageModel>("QuranQuick",1,0,"PageModel");
//    qRegisterMetaType<PageModel*>("PageModel");
//    qRegisterMetaType<Translation::Status>("TranslationStatus");
    QGuiApplication *app = SailfishApp::application(argc, argv);

//    qRegisterMetaType<PageModel*>("PageModel");
//    Controller *c = new Controller;
//    c->init();

    QQuickView *view = SailfishApp::createView();

    QQmlContext *rootContext = view->rootContext();
    rootContext->setContextProperty("Quran", &quran);
    rootContext->setContextProperty("Translation", &translation);
    rootContext->setContextProperty("Searching", &searching);
    rootContext->setContextProperty("Bookmarking", &bookmarking);

    /*view->rootContext()->setContextProperty("ImageUtils", new ImageUtils);*/
    view->setSource(SailfishApp::pathTo("qml/sailquran.qml"));
    view->show();

    man.openDB();

    int ret = app->exec();

//    delete c;
    delete view;
    delete app;

    return ret;
}
