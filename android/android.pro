TARGET = sailquran
TEMPLATE = app

QT += core sql qml quick quickcontrols2 svg xml

CONFIG += c++11

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

OBJECTS_DIR=generated_files #Intermediate object files directory
MOC_DIR=generated_files #Intermediate moc files directory
RCC_DIR=generated_files #Intermediate qrc files directory

# mandatory if we want to include quazip's source code to project
LIBS += -lz
DEFINES += QUAZIP_STATIC

include(../3rdparty/quazip/quazip.pri)
include(../src/src.pri)

SOURCES += main.cpp

RESOURCES += qml.qrc \
    ../db.qrc \
    ../flags.qrc \
    ../fonts.qrc \
    icons.qrc \
    js.qrc
#    ../apks.qrc \
#    resources.qrc \
#    components.qrc

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
    android-build/build.gradle \
    android-build/gradle/wrapper/gradle-wrapper.jar \
    android-build/gradle/wrapper/gradle-wrapper.properties \
    android-build/gradlew \
    android-build/gradlew.bat \
    android-build/res/values/libs.xml
