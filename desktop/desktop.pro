TARGET = sailquran
TEMPLATE = app

#QT += core gui declarative network sql
QT += core sql qml quick quickcontrols2

CONFIG += c++11

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
OBJECTS_DIR=generated_files #Intermediate object files directory
MOC_DIR=generated_files #Intermediate moc files directory
RCC_DIR=generated_files #Intermediate qrc files directory

DEFINES += QUAZIP_STATIC
INCLUDEPATH += $$[QT_INSTALL_HEADERS]/QtZlib

include(../3rdparty/3rdparty.pri)
include(../src/src.pri)

include(../3rdparty/singleapplication/singleapplication.pri)
DEFINES += QAPPLICATION_CLASS=QApplication

#include(gui/gui.pri)
#include(declarative/declarative.pri)

SOURCES += main.cpp
#        SingleApplication.cpp

#HEADERS  += \
#        build.h \
#        SingleApplication.h

RESOURCES += qml.qrc \
    ../db.qrc \
    ../flags.qrc \
    ../fonts.qrc \
    ../icons.qrc \
    ../js.qrc
#    ../apks.qrc \
#    resources.qrc \
#    components.qrc

RC_FILE += resources.rc

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

DISTFILES += \
    qml/main.qml \
    qml/pages/AboutPage.qml \
    qml/pages/BookmarkPage.qml \
    qml/pages/IndexPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/SettingPage.qml \
    qml/pages/TranslationPage.qml
