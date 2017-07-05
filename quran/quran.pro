TARGET = Quran
TEMPLATE = app

Q#T += core gui declarative network sql
QT += core sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

#uncomment if want to use libcef
#libcef is (hopefully will be fully) deprecated because libcef sometime unstable on some cases.
#CONFIG += USE_LIBCEF
#USE_LIBCEF {
#    DEFINES += LIBCEF

#    win32-msvc* {
#        LIBS +=  -L$$PWD/../libs/msvc/ -llibcef \
#                 -L$$PWD/../libs/msvc/ -llibcef_dll
#    }

#    RESOURCES += \
#        webview.qrc \
}
else {
    QT += webkit
}

OBJECTS_DIR=generated_files #Intermediate object files directory
MOC_DIR=generated_files #Intermediate moc files directory
RCC_DIR=generated_files #Intermediate qrc files directory

# mandatory if we want to include quazip's source code to project
#DEFINES += QUAZIP_STATIC

#include(../3rdparty/3rdparty.pri)
#include(../src/src.pri)

#include(gui/gui.pri)
#include(declarative/declarative.pri)

SOURCES += main.cpp \
        SingleApplication.cpp

HEADERS  += \
        build.h \
        SingleApplication.h

#RESOURCES += \
#    ../images.qrc \
#    ../fonts.qrc \
#    ../scripts.qrc \
#    ../apks.qrc \
#    resources.qrc \
#    components.qrc

#RC_FILE += resources.rc

#win32 {
#    QMAKE_LFLAGS_WINDOWS += /MANIFESTUAC:level=\'requireAdministrator\'
#}

#lupdate_only {
#    OTHER_FILES = qml/AboutPopup.qml
#}
