INCLUDEPATH += $$PWD

include(paging/paging.pri)
include(searching/searching.pri)
include(translation/translation.pri)
include(quran/quran.pri)

HEADERS += \
    $$PWD/GlobalConstants.h

webassembly {
    DEFINES += USE_API
    include(api/api.pri)
} else {
    include(bookmarking/bookmarking.pri)
    include(downloader/downloader.pri)
    include(utils/utils.pri)
    include(sqlite/sqlite.pri)

    HEADERS += \
        $$PWD/GlobalFunctions.h

    SOURCES += \
        $$PWD/GlobalFunctions.cpp
}
