#include "GlobalFunctions.h"
#include "GlobalConstants.h"

#if QT_VERSION >= 0x050000
    #include <QStandardPaths>
#endif

const QString GlobalFunctions::databaseLocation() {
    QString filepath = QString("%1/%2").arg(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)).arg(DB_NAME);
    return filepath;
}
const QString GlobalFunctions::dataLocation() {
    QString path = QString("%1/").arg(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    return path;
}

const QString GlobalFunctions::translationLocation() {
    QString path = QString("%1/translation/").arg(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    return path;
}
