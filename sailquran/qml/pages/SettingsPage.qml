import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components" as Components

Page {
    id: settingPage
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
        contentHeight: header.height + preview.height + textStyleCombobox.height + translationCombobox.height + fontSizeSlider.height + translationFontSizeSlider.height + backgroundImageSwitch.height + fontColorLabel.height + fontColorPicker.height

        /*PullDownMenu {
            MenuItem {
                text: "Clear Database"
                onClicked: {
                    var dialog = pageStack.push(
                                Qt.resolvedUrl("../components/ConfirmationDialog.qml"),
                                    {
                                        "title": "Clear database?",
                                        "description": "This action will also erase your bookmarks and custom translations",
                                    }
                                );
                    dialog.accepted.connect(function() {
                        console.log("Database cleared");
                    })
                }
            }
            MenuItem {
                text: "Reset Settings"
                onClicked: {
                    var dialog = pageStack.push(
                                Qt.resolvedUrl("../components/ConfirmationDialog.qml"),
                                    {
                                        "title": "Reset settings?",
                                        "description": "This action will reset your settings to default value",
                                    }
                                );
                    dialog.accepted.connect(function() {
                        console.log("Settings reset");
                    })
                }
            }

            MenuItem {
                text: "Manage Translations"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("TranslationsPage.qml"));
                }
            }
        }*/

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

        Rectangle {
            anchors.fill: preview
            color: Settings.backgroundColor
            visible: Settings.useBackground
        }

        SilicaListView {
            id: preview
            height: childrenRect.height
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
                    color: Settings.fontColor
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
                    font { pixelSize: Settings.fontSize; }
                    font.family: constant.fontName
                }
                Label {
                    id: translationLabel
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignJustify
                    color: Settings.fontColor
                    height: paintedHeight + constant.paddingMedium
                    anchors {
                        top: textLabel.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: model.translation
                    font.pixelSize: Settings.translationFontSize
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
                MenuItem { text: "Original" }
                MenuItem { text: "Enhanced" }
                MenuItem { text: "Uthmani" }
//                MenuItem { text: "Simplified" }
            }

            onCurrentIndexChanged: {
                var textType = "quran_text_original";
                if(currentIndex == 1)
                    textType = "quran_text_enhanced";
                else if(currentIndex == 2)
                    textType = "quran_text_uthmani";
                else if(currentIndex == 3)
                    textType = "quran_text";

                settingPage.textType = textType;
                Controller.preview.textType = textType;
                Controller.preview.refresh()
            }

            Component.onCompleted: {
                var index = 0;
                if(Settings.textType === "quran_text_enhanced")
                    index = 1;
                else if(Settings.textType === "quran_text_uthmani")
                    index = 2;
                else if(Settings.textType === "quran_text")
                    index = 3;

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
                Controller.preview.translation = translation;
                Controller.preview.refresh()
            }

            Component.onCompleted: {
                var index = 0;
                if(Settings.translation === "en_sahih")
                    index = 1;

                currentIndex = index;
            }
        }

        Slider {
            id: fontSizeSlider
            anchors {
                left: parent.left
                right: parent.right
                top: translationCombobox.bottom
            }
            label: "Font Size"
            minimumValue: 25
            maximumValue: 50
//            value: 32
            valueText: Math.round(value)

            onValueChanged: Settings.fontSize = Math.round(value)

            Component.onCompleted: value = Settings.fontSize
        }

        Slider {
            id: translationFontSizeSlider
            anchors {
                left: parent.left
                right: parent.right
                top: fontSizeSlider.bottom
            }
            label: "Translation Font Size"
            minimumValue: 15
            maximumValue: 35
//            value: 20
            valueText: Math.round(value)

            onValueChanged: Settings.translationFontSize = Math.round(value)

            Component.onCompleted: value = Settings.translationFontSize
        }

        TextSwitch {
             id: backgroundImageSwitch
             text: "Use Background"
             checked: Settings.useBackground
//             onCheckedChanged: {
//                 device.setStatus(checked ? DeviceState.Armed : DeviceState.Disarmed)
//             }
             anchors {
                 left: parent.left
                 right: parent.right
                 top: translationFontSizeSlider.bottom
                 topMargin: 15
             }
             onCheckedChanged: {
                 Settings.useBackground = checked
                 if(checked && Settings.fontColor === "#ffffff") {
                     Settings.fontColor = "#000000"
                 }
                 else if(!checked) {
                     Settings.fontColor = "#ffffff"
                 }
             }
         }

        Label {
            id: fontColorLabel
            anchors {
                left: parent.left
                right: parent.right
                top: backgroundImageSwitch.bottom
                topMargin: 15
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Theme.primaryColor
            wrapMode: Text.WordWrap
            text: "Font Color"
            visible: Settings.useBackground
        }

        ColorPicker {
            id: fontColorPicker
            anchors {
                left: parent.left
                right: parent.right
                top: fontColorLabel.bottom
            }
            columns: 5
            height: width/5
            colors: Settings.useBackground ? ["black", "darkblue", "darkred", "darkgreen", "gray"] : ["white", "darkblue", "darkred", "darkgreen", "gray"]

            onColorChanged: Settings.fontColor = color
            visible: Settings.useBackground
        }

        /*Label {
            id: backgroundColorLabel
            anchors {
                left: parent.left
                right: parent.right
                top: fontColorPicker.bottom
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Theme.primaryColor
            wrapMode: Text.WordWrap
            text: "Font Color"
        }

        ColorPicker {
            id: backgroundColorPicker
            anchors {
                left: parent.left
                right: parent.right
                top: backgroundColorLabel.bottom
            }
            columns: 5
            height: width/5
            colors: ["black", "white", "darkred", "darkgreen", "gray"]
        }*/
    }
}

