TEMPLATE = subdirs
#CONFIG += sailfishapp

equals(QT_MAJOR_VERSION, 5) {
    sailfishapp {
        SUBDIRS += \
            sailquran
    }
    else:android {
        SUBDIRS += \
            Quran-Android
    }
    else {
        SUBDIRS += \
            quran
    }
}

#equals(QT_MAJOR_VERSION, 4) {
#    CONFIG += static
#    static {
#        SUBDIRS += \
#    }
#    else {
#        SUBDIRS += \
#    }
#}

