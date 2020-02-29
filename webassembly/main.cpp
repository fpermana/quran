#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "GlobalConstants.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QCoreApplication::setOrganizationName(SETTINGS_ORGANIZATION);
    QCoreApplication::setOrganizationDomain(SETTINGS_DOMAIN);
    QCoreApplication::setApplicationName(SETTINGS_APPLICATION);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
