#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
/*#include "core/Controller.h"
#include "core/Settings.h"
#include "model/PageModel.h"*/
#include "GlobalConstants.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName(SETTINGS_ORGANIZATION);
    QCoreApplication::setOrganizationDomain(SETTINGS_DOMAIN);
    QCoreApplication::setApplicationName(SETTINGS_APPLICATION);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    /*qmlRegisterType<PageModel>("QuranQuick",1,0,"PageModel");
    qRegisterMetaType<PageModel*>("PageModel");

    Controller *c = new Controller;
    c->init();*/

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
//    context->setContextProperty("Controller", c);
//    context->setContextProperty("Settings", c->getSettings());

    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
