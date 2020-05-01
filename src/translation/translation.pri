INCLUDEPATH += $$PWD

HEADERS += \
    $$PWD/Translation.h \
    $$PWD/TranslationListModel.h \
    $$PWD/TranslationModel.h

SOURCES += \
    $$PWD/Translation.cpp \
    $$PWD/TranslationListModel.cpp \
    $$PWD/TranslationModel.cpp


!webassembly {
    HEADERS += \
        $$PWD/TranslationParser.h

    SOURCES += \
        $$PWD/TranslationParser.cpp
}
