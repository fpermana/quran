INCLUDEPATH += $$PWD

# mandatory if we want to include quazip's source code to project
#LIBS += -lz
#DEFINES += QUAZIP_STATIC

#INCLUDEPATH += $$[QT_INSTALL_PREFIX]/src/3rdparty/zlib
#INCLUDEPATH += $$[QT_INSTALL_HEADERS]/QtZlib

include(quazip/quazip.pri)
