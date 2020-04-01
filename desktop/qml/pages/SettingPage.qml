import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Universal 2.12
import id.fpermana.sailquran 1.0
import "../components" as Comp

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

            var itemCount = translationDropdown.count
            for(var i=0; i<itemCount; i++) {
                var model = translationList.get(i);
                var tid = model.tid;
                tid = tid.replace(".", "_");
                if(tid === Quran.translation) {
                    translationDropdown.currentIndex = i;
                    break;
                }
            }
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + 30

        Column {
            id: contentColumn
            height: childrenRect.height
            spacing: 15
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
                Comp.Label {
                    id: textLabel
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
                    font { pixelSize: Quran.fontSize; family: Quran.fontName }
                }
                Comp.Label {
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

            Comp.Dropdown {
                id: textStyleDropdown
                title: qsTr("Quran Text")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                initValue: Quran.quranText

                model: ListModel {
                    ListElement { name: "Original"; value: "quran_text_original" }
                    ListElement { name: "Enhanced"; value: "quran_text_enhanced" }
                    ListElement { name: "Uthmani"; value: "quran_text_uthmani" }
                }

                onValueChanged: {
                    Quran.quranText = value
                }
            }
            Comp.Label {
                text: qsTr("Font Size") + ": " + fontSizeSlider.value
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Slider {
                id: fontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                stepSize: 1
                from: 15
                to: 70
                value: Quran.fontSize

                onValueChanged: {
                    Quran.fontSize = value
                }
            }

            ItemDelegate {
                height: 60
                anchors {
                    left: parent.left
                    right: parent.right
//                    leftMargin: constant.paddingMedium
//                    rightMargin: constant.paddingMedium
                }

                Comp.CheckBox {
                    id: useTranslationSwitch
                    text: qsTr("Use Translation")
                    checked: Quran.useTranslation
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                    onCheckedChanged: {
                        Quran.useTranslation = checked
                    }
                }
            }

            Comp.Label {
                text: qsTr("Translation Font Size") + ": " + translationFontSizeSlider.value
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
                stepSize: 1
                visible: Quran.useTranslation
                from: 15
                to: 35
                value: Quran.translationFontSize

                onValueChanged: {
                    Quran.translationFontSize = value
                }
            }

            Comp.Dropdown {
                id: translationDropdown
                title: qsTr("Translation")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                initValue: Quran.translation.replace("_",".")

                visible: Quran.useTranslation
                model: translationList
                valueRole: "tid"

                onValueChanged: {
                    Quran.translation = value.replace(".","_")
                }
            }

            Comp.Button {
                anchors {
                    right: parent.right
                    margins: 15
                }
                text: qsTr("Manage Translations")
                visible: Quran.useTranslation
                onClicked: {
                    stackView.push("qrc:/qml/pages/TranslationPage.qml")
                }
            }

            ItemDelegate {
                height: 60
                anchors {
                    left: parent.left
                    right: parent.right
//                    leftMargin: constant.paddingMedium
//                    rightMargin: constant.paddingMedium
                }
                Comp.CheckBox {
                    id: useBackgroundSwitch
                    text: qsTr("Dark Mode")
                    checked: Setting.universalTheme
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                    onCheckedChanged: {
//                        Quran.useBackground = checked
//                        Universal.theme = checked ? Universal.Dark : Universal.Light
                        applicationWindow.changeTheme(checked ? Universal.Dark : Universal.Light)
                        if(checked) {
                            Quran.fontColor = "#ffffff"
                        }
                        else if(!checked) {
                            Quran.fontColor = "#000000"
                        }

                        Setting.universalTheme = checked ? Universal.Dark : Universal.Light
                    }
                }
            }
            Row {
                height: 60
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 15
                }
                spacing: 15
                layoutDirection: Qt.RightToLeft

                Comp.Button {
                    text: qsTr("Save Settings")
                    onClicked: {
                        Setting.saveSetting()
                        Quran.saveSettings()
                    }
                }

                Comp.Button {
                    text: qsTr("Reset Settings")
                    onClicked: {
                        Setting.resetSetting()
                        Quran.resetSettings()
                        Setting.saveSetting()
                        Quran.saveSettings()
                    }
                }
            }
        }
    }
}
