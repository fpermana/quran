TARGET = Quran
TEMPLATE = app

#QT += core gui declarative network sql
QT += core sql qml quick

CONFIG += c++11

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
#}
#else {
#    QT += webkit
#}

OBJECTS_DIR=generated_files #Intermediate object files directory
MOC_DIR=generated_files #Intermediate moc files directory
RCC_DIR=generated_files #Intermediate qrc files directory

# mandatory if we want to include quazip's source code to project
LIBS += -lz
DEFINES += QUAZIP_STATIC

include(../3rdparty/3rdparty.pri)
include(../src/src.pri)

#include(gui/gui.pri)
#include(declarative/declarative.pri)

SOURCES += main.cpp
#        SingleApplication.cpp

#HEADERS  += \
#        build.h \
#        SingleApplication.h

RESOURCES += qml.qrc \
    ../db.qrc #\
    #../fonts.qrc
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

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-build

DISTFILES += \
    android-build/AndroidManifest.xml \
    android-build/gradle/wrapper/gradle-wrapper.jar \
    android-build/gradlew \
    android-build/res/values/libs.xml \
    android-build/build.gradle \
    android-build/gradle/wrapper/gradle-wrapper.properties \
    android-build/gradlew.bat
