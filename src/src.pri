INCLUDEPATH += $$PWD

#include(config/config.pri)
include(core/core.pri)
#include(client/client.pri)
include(helper/helper.pri)
include(network/network.pri)
#include(patcher/patcher.pri)
#include(utils/utils.pri)
include(model/model.pri)
include(database/database.pri)

HEADERS += \
    $$PWD/GlobalFunctions.h \
    $$PWD/GlobalConstants.h

SOURCES += \
    $$PWD/GlobalFunctions.cpp
