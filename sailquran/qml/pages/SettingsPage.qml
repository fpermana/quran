import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: settingPage
//    onStatusChanged: console.log(settingPage.status)
//    allowedOrientations: Orientation.All
    property string textType
    property string translation

    onStatusChanged: {
        if(settingPage.status === PageStatus.Deactivating) {
            if(settingPage.textType !== Settings.textType || settingPage.translation !== Settings.translation) {
                Settings.textType = settingPage.textType;
                Settings.translation = settingPage.translation;

                Settings.saveSettings();
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        Item {
            id: header
            height: constant.headerHeight
            width: parent.width
            anchors {
                top: parent.top
                right: parent.right
                margins: constant.paddingMedium
            }

            Label {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }
                verticalAlignment: Text.AlignVCenter
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                text: "Settings"
            }
        }

        SilicaListView {
            id: preview
            height: constant.headerHeight
            focus: true
            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
            }
            interactive: false
            model: Controller.preview

            delegate: Item {
                height: childrenRect.height
                width: preview.width
                Label {
                    id: textLabel
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: constant.colorLight
                    height: paintedHeight + constant.paddingLarge
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: model.text
                    font { pixelSize: constant.fontSizeLarge; }
                    font.family: constant.fontName
                }
            }
        }

        ComboBox {
            id: textStyleCombobox
            anchors {
                left: parent.left
                right: parent.right
                top: preview.bottom
            }

            label: "Text Style"

            menu: ContextMenu {
                MenuItem { text: "Simplified" }
                MenuItem { text: "Enhanced" }
                MenuItem { text: "Uthmani" }
            }

            onCurrentIndexChanged: {
                var textType = "quran_text";
                if(currentIndex == 1)
                    textType = "quran_text_enhanced";
                else if(currentIndex == 2)
                    textType = "quran_text_uthmani";

                settingPage.textType = textType;
                Controller.preview.textType = textType;
                Controller.preview.refresh()
            }

            Component.onCompleted: {
                var index = 0;
                if(Settings.textType == "quran_text_enhanced")
                    index = 1;
                else if(Settings.textType == "quran_text_uthmani")
                    index = 2;

                currentIndex = index;
            }
        }

        ComboBox {
            id: translationCombobox
            anchors {
                left: parent.left
                right: parent.right
                top: textStyleCombobox.bottom
            }

            label: "Translation"

            menu: ContextMenu {
                MenuItem { text: "Indonesian" }
                MenuItem { text: "English" }
            }

            onCurrentIndexChanged:  {
                var translation = "id_indonesian";
                if(currentIndex == 1)
                    translation = "en_sahih";
                settingPage.translation = translation;
            }

            Component.onCompleted: {
                var index = 0;
                if(Settings.translation == "en_sahih")
                    index = 1;

                currentIndex = index;
            }
        }
    }
}
