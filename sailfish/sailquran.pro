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
TARGET = harbour-sailquran

QT += sql

CONFIG += sailfishapp

SOURCES += src/sailquran.cpp

LIBS += -lz
DEFINES += QUAZIP_STATIC

include(../3rdparty/3rdparty.pri)
include(../src/src.pri)

OTHER_FILES += qml/sailquran.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/IndexPage.qml \
    qml/pages/BookmarkPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/SettingPage.qml \
    qml/pages/TranslationPage.qml \
    qml/components/Constant.qml \
    qml/components/ConfirmationDialog.qml \
    qml/components/IconMenuItem.qml \
    qml/components/SearchDialog.qml \
    translations/*.ts

RESOURCES += \
    ../db.qrc \
    ../flags.qrc \
    ../fonts.qrc \
    ../js.qrc \
    ../icons.qrc

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
# TRANSLATIONS += translations/sailquran-de.ts

DISTFILES += \
    rpm/harbour-sailquran.changes.in \
    rpm/harbour-sailquran.changes.run.in \
    rpm/harbour-sailquran.spec \
    rpm/harbour-sailquran.yaml \
    harbour-sailquran.desktop
