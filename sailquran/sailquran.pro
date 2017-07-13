# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = sailquran

QT += sql


CONFIG += sailfishapp

SOURCES += src/sailquran.cpp

LIBS += -lz
#DEFINES += QUAZIP_STATIC

include(../3rdparty/3rdparty.pri)
include(../src/src.pri)

OTHER_FILES += qml/sailquran.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SecondPage.qml \
    qml/pages/ThirdPage.qml \
    rpm/sailquran.changes.in \
    rpm/sailquran.spec \
    rpm/sailquran.yaml \
    translations/*.ts \
    sailquran.desktop

RESOURCES += \
    ../db.qrc \
    ../fonts.qrc \
    ../js.qrc

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/sailquran-de.ts

DISTFILES += \
    qml/components/Constant.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/IndexPage.qml
