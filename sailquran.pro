TEMPLATE = subdirs

equals(QT_MAJOR_VERSION, 5) {
    android {
        SUBDIRS += \
            android
    } else {
        SUBDIRS += \
            desktop
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

