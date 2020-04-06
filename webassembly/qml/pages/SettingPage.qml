import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import id.fpermana.sailquran 1.0
import "../components" as Comp

Comp.Page {
    id: settingPage

//    property TranslationList translationList
    menu: Comp.Menu {
        MenuItem {
            text: qsTr("Manage Translations")
            onTriggered: {
                appStackView.push("qrc:/qml/pages/TranslationPage.qml")
            }
        }
        MenuItem {
            text: qsTr("Reset Settings")
            onTriggered: {
                Setting.resetSetting()
                Quran.resetSettings()
                Setting.saveSetting()
                Quran.saveSettings()
            }
        }
    }

    title: qsTr("Setting")

    Component.onCompleted: {
        Translation.getActiveTranslation()
    }

    ListModel {
        id: listModel
    }

    Connections {
        target: Translation
        onActiveTranslationLoaded: {
//            translationDropdown.model = translation
            var count = translation.count()
            var ci = -1
            listModel.clear()
            for(var i=0; i<count; i++){
                var name = translation.get(i).name
                var tid = translation.get(i).tid
                tid = tid.replace(".","_")
                if(tid === Quran.translation)
                    ci = i
                listModel.append({"name":name,"value":tid})
            }
            translationDropdown.model = listModel
            translationDropdown.currentIndex = ci
        }
    }

    Item {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
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

    Flickable {
        id: flickable
        anchors {
            fill: parent
            topMargin: header.height
        }
        contentHeight: contentColumn.height + 30
        clip: true

        Column {
            id: contentColumn
            height: childrenRect.height
            spacing: 10
            anchors {
                left: parent.left
                right: parent.right
            }

            /*Item {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: header.height

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
            }*/

            /*Comp.Dropdown {
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
            }*/

            Comp.Label {
                text: qsTr("Quran Text")
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 15
                }
            }

            ComboBox {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                model: ListModel {
                    ListElement { name: "Original"; value: "quran_text_original" }
                    ListElement { name: "Enhanced"; value: "quran_text_enhanced" }
                    ListElement { name: "Uthmani"; value: "quran_text_uthmani" }
                }
                textRole: "name"

                Component.onCompleted: {
                    for(var i=0; i<count; i++) {
                        var c = model.get(i).value
                        if(c === Quran.quranText) {
                            currentIndex = i
                            break
                        }
                    }
                }

                onActivated: {
                    Quran.quranText = model.get(index).value
                    Quran.saveSettings()
                }
            }

            Comp.Label {
                text: qsTr("Font Size") + ": " + fontSizeSlider.value
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 15
                }
            }

            Slider {
                id: fontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                stepSize: 1
                from: 10
                to: 70
                value: Quran.fontSize

                onValueChanged: {
                    Quran.fontSize = value
                    Quran.saveSettings()
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
                        Quran.saveSettings()
                    }
                }
            }

            Comp.Label {
                text: qsTr("Translation Font Size") + ": " + translationFontSizeSlider.value
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 15
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
                from: 10
                to: 35
                value: Quran.translationFontSize

                onValueChanged: {
                    Quran.translationFontSize = value
                    Quran.saveSettings()
                }
            }

            /*Comp.Dropdown {
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
            }*/

            Comp.Label {
                text: qsTr("Translation")
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 15
                }
            }

            ComboBox {
                id: translationDropdown
                anchors {
                    left: parent.left
                    right: parent.right
                }

                visible: Quran.useTranslation
//                model: translationList
                model: Translation.activeTranslationList
                textRole: "name"

                /*Component.onCompleted: {
                    for(var i=0; i<count; i++) {
                        if(model.get(i) === null)
                            continue
                        console.log(model.get(i))
                        var t = model.get(i).tid.replace(".","_")
                        if(t === Quran.translation) {
                            currentIndex = i
                            break
                        }
                    }
                }*/
                /*onModelChanged: {
                    for(var i=0; i<count; i++) {
                        var m = model.get(i);
                        var tid = m.tid;
                        tid = tid.replace(".", "_");
                        if(tid === Quran.translation) {
                            currentIndex = i;
                            break;
                        }
                    }
                }*/

                onActivated: {
//                    console.log(index)
//                    if(model.get(index) !== null) {
//                        var tid = model.get(index).value
//                        console.log(tid)
//                        tid = tid.replace(".","_")
                        Quran.translation = model.get(index).value
                        Quran.saveSettings()
//                    }
                }
            }

            /*Comp.Button {
                anchors {
                    right: parent.right
                    margins: 15
                }
                text: qsTr("Manage Translations")
                visible: Quran.useTranslation
                onClicked: {
                    appStackView.push("qrc:/qml/pages/TranslationPage.qml")
                }
            }*/

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
                    checked: Setting.materialTheme == Material.Dark
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
                        applicationWindow.changeTheme(checked ? Material.Dark : Material.Light)
                        if(checked) {
                            Quran.fontColor = "#ffffff"
                        }
                        else if(!checked) {
                            Quran.fontColor = "#000000"
                        }

                        Quran.saveSettings()
                        Setting.saveSetting()
                    }
                }
            }

            Comp.Label {
                text: qsTr("App Font Size") + ": " + appFontSizeSlider.value
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 15
                }
            }

            Slider {
                id: appFontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                stepSize: 1
                from: 10
                to: 35
                value: Setting.fontSize

                onValueChanged: {
                    Setting.fontSize = value
                    Setting.smallFontSize = value - 4
                    Setting.largeFontSize = value + 6

                    Setting.saveSetting()
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

                /*Comp.Button {
                    text: qsTr("Save Settings")
                    width: parent.width * 0.4
                    onClicked: {
                        Setting.saveSetting()
                        Quran.saveSettings()
                    }
                }*/

                /*Comp.Button {
                    text: qsTr("Reset Settings")
                    width: parent.width * 0.45
                    onClicked: {
                        Setting.resetSetting()
                        Quran.resetSettings()
                        Setting.saveSetting()
                        Quran.saveSettings()
                    }
                }*/
            }
        }
    }
}
