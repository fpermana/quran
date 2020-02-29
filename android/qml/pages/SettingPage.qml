import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0

Page {
    id: settingPage

    property TranslationList translationList

    title: qsTr("Setting")

    Component.onCompleted: {
        Translation.getActiveTranslation()
    }

    Connections {
        target: Translation
        onActiveTranslationLoaded: {
            translationList = translation

            var itemCount = translationCombobox.count
            for(var i=0; i<itemCount; i++) {
                var model = translationList.get(i);
                var tid = model.tid;
                tid = tid.replace(".", "_");
                if(tid === Quran.translation) {
                    translationCombobox.currentIndex = i;
                    break;
                }
            }
        }
    }

    /*property Drawer menu: Drawer {
        id: drawer
        width: applicationWindow.width * 0.66
        height: applicationWindow.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                width: parent.width
//                height: childrenRect.height
                background: Rectangle {
                    color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
                }

                Label {
                    verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                    color: constant.colorDark
                    height: paintedHeight + constant.paddingLarge
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: qsTr("Translation")
                    font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                }

                Component.onCompleted: {
                    height = childrenRect.height
                }

                onClicked: {
                    stackView.push("qrc:/qml/pages/TranslationPage.qml")
                    drawer.close()
                }
            }
        }
    }*/
//    allowedOrientations: Orientation.All
    /*property string textType
    property string translation

    onStatusChanged: {
        if(settingPage.status === PageStatus.Deactivating) {
            if(settingPage.textType !== Settings.textType || settingPage.translation !== Settings.translation) {
                Settings.textType = settingPage.textType;
                Settings.translation = settingPage.translation;

                Settings.saveSettings();
            }
        }
    }*/

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            height: childrenRect.height
            anchors {
                left: parent.left
                right: parent.right
            }

            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                height: childrenRect.height
                Label {
                    id: textLabel
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: Quran.fontColor
                    height: paintedHeight + constant.paddingLarge
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: Quran.preview !== null ? Quran.preview.text : ""
                    font { pixelSize: Quran.fontSize; family: constant.fontName }
                }
                Label {
                    id: translationLabel
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignJustify
                    color: Quran.fontColor
                    visible: Quran.useTranslation
                    height: visible ? (paintedHeight + constant.paddingMedium) : 0
                    anchors {
                        top: textLabel.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: Quran.preview !== null ? Quran.preview.translation : ""
                    font { pixelSize: Quran.translationFontSize; }
                }
            }

            ComboBox {
                id: textStyleCombobox
                anchors {
                    left: parent.left
                    right: parent.right
                }

                textRole: "key"
                model: ListModel {
                    id: quranTextModel
                    ListElement { key: "Original"; value: "quran_text_original" }
                    ListElement { key: "Enhanced"; value: "quran_text_enhanced" }
                    ListElement { key: "Uthmani"; value: "quran_text_uthmani" }
                }
                onActivated: {
                    console.log(quranTextModel.get(index))

                }
            }

            /*Slider {
                id: fontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                label: "Font Size"
                minimumValue: 25
                maximumValue: 50
    //            value: 32
                valueText: Math.round(value)

                onValueChanged: Settings.fontSize = Math.round(value)

                Component.onCompleted: value = Settings.fontSize
            }*/
            Switch {
                id: useTranslationSwitch
                text: qsTr("Use Translation")
                checked: Quran.useTranslation
                anchors {
                    left: parent.left
                    right: parent.right
                }
                onCheckedChanged: {
                    Quran.useTranslation = checked
                }
            }

            ComboBox {
                id: translationCombobox
                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: Quran.useTranslation
                model: translationList
                textRole: "name"
            }
            Button {
                anchors.right: parent.right
                text: qsTr("Manage Translations")
                onClicked: {
                    stackView.push("qrc:/qml/pages/TranslationPage.qml")
                }
            }
            Label {
                text: qsTr("Translation Font Size")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: Quran.useTranslation
            }

            Slider {
                id: translationFontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: Quran.useTranslation
                from: 15
                to: 35
    //            value: 20
//                valueText: Math.round(value)

//                onValueChanged: Settings.translationFontSize = Math.round(value)

//                Component.onCompleted: {
//                    value = Settings.translationFontSize
//                }
            }

            Switch {
                id: useBackgroundSwitch
                text: qsTr("Use Background")
                checked: Quran.useBackground
                anchors {
                    left: parent.left
                    right: parent.right
                }
                onCheckedChanged: {
                    Quran.useBackground = checked
                    if(checked && Quran.fontColor === "#ffffff") {
                        Quran.fontColor = "#000000"
                    }
                    else if(!checked) {
                        Quran.fontColor = "#ffffff"
                    }
                }
            }

            /*Label {
                id: fontColorLabel
                anchors {
                    left: parent.left
                    right: parent.right
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
                }
                columns: 5
                height: width/5
                colors: Settings.useBackground ? ["black", "darkblue", "darkred", "darkgreen", "gray"] : ["white", "darkblue", "darkred", "darkgreen", "gray"]

                onColorChanged: Settings.fontColor = color
                visible: Settings.useBackground
            }*/
        }
    }
}
