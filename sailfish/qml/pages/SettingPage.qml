import QtQuick 2.1
import Sailfish.Silica 1.0
import id.fpermana.sailquran 1.0
import "../components"

Page {
    id: settingPage
//    allowedOrientations: Orientation.All

    property TranslationList translationList

    function getQuranText() {
        var current = textStyleCombobox.currentIndex
        if(current === 0)
            return "quran_text_original"
        else if(current === 1)
            return "quran_text_enhanced"
        else if(current === 2)
            return "quran_text_uthmani"
    }

    function getTranslation() {
        var model = translationList.get(Math.max(0,translationCombobox.currentIndex));
        var tid = model.tid
        tid = tid.replace(".", "_");
        return tid
    }

    Component.onCompleted: {
        Translation.getActiveTranslation()
    }

    Connections {
        target: Translation
        onActiveTranslationLoaded: {
            translationList = translation;
            var itemCount = translationRepeater.count
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

    onStatusChanged: {
        if(settingPage.status === PageStatus.Deactivating) {
//            if(settingPage.quranText !== Quran.quranText || settingPage.translation !== Quran.translation) {
                Quran.quranText = getQuranText();
                Quran.translation = getTranslation();

                Quran.saveSettings();
//            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        PullDownMenu {
            /*MenuItem {
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
            }*/

            MenuItem {
                text: qsTr("Manage Translations")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("TranslationPage.qml"));
                }
            }
        }

        Column {
            id: contentColumn
            height: childrenRect.height
            anchors {
                left: parent.left
                right: parent.right
            }

            Item {
                id: header
                height: constant.headerHeight
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Label {
                    anchors {
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                        rightMargin: constant.paddingMedium
                    }
                    verticalAlignment: Text.AlignVCenter
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Settings")
                }
            }

            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: preview.height

                Rectangle {
                    anchors.fill: preview
                    color: Quran.backgroundColor
                    visible: Quran.useBackground
                }

                /*SilicaListView {
                    id: preview
                    height: childrenRect.height
                    focus: true
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    interactive: false
                    model: Quran.preview

                    delegate: */Item {
                        id: preview
                        height: childrenRect.height
                        width: parent.width
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
//                            text: model.text
                            text: Quran.preview !== null ? Quran.preview.text : ''
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
//                            text: model.translation
                            text: Quran.preview !== null ? Quran.preview.translation : ''
                            font { pixelSize: Quran.translationFontSize; }
                        }
                    }
//                }
            }

            ComboBox {
                id: textStyleCombobox
                anchors {
                    left: parent.left
                    right: parent.right
                }

                label: qsTr("Text Style")

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Original")
                        onClicked: {
                            Quran.refreshPreview("quran_text_original", getTranslation())
                        }
                    }
                    MenuItem {
                        text: qsTr("Enhanced")
                        onClicked: {
                            Quran.refreshPreview("quran_text_enhanced", getTranslation())
                        }
                    }
                    MenuItem {
                        text: qsTr("Uthmani")
                        onClicked: {
                            Quran.refreshPreview("quran_text_uthmani", getTranslation())
                        }
                    }
                }

                Component.onCompleted: {
                    var index = 0;
                    if(Quran.quranText === "quran_text_enhanced")
                        index = 1;
                    else if(Quran.quranText === "quran_text_uthmani")
                        index = 2;
                    else if(Quran.quranText === "quran_text")
                        index = 3;

                    currentIndex = index;
                }
            }

            Slider {
                id: fontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                label: qsTr("Font Size")
                minimumValue: 25
                maximumValue: 50
    //            value: 32
                valueText: Math.round(value)

                onValueChanged: Quran.fontSize = Math.round(value)

                Component.onCompleted: value = Quran.fontSize
            }
            TextSwitch {
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
                label: qsTr("Translation")
                menu: ContextMenu {
                    Repeater {
                        id: translationRepeater
                        model: translationList
                        IconMenuItem {
                            text: model.name + ( (translationRepeater.count>5 && model.name !== model.lang) ? (" " + model.lang) : "" );
                            icon: "qrc:/flags/" + model.flag + ".png"

                            onClicked: {
                                var translation = model.tid;
                                translation = translation.replace(".", "_");
                                Quran.refreshPreview(getQuranText(), translation)
                            }
                        }
                    }
                }

                /*Component.onCompleted: {
                    var itemCount = translationRepeater.count
                    for(var i=0; i<itemCount; i++) {
                        var translation = translationList.get(i);
                        console.log(translation.tid)
                        var tid = cit.tid;
                        tid = tid.replace(".", "_");
                        if(tid === Quran.translation) {
                            currentIndex = i;
                            break;
                        }
                    }
                }*/
            }

            Slider {
                id: translationFontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: Quran.useTranslation
                label: qsTr("Translation Font Size")
                minimumValue: 15
                maximumValue: 35
    //            value: 20
                valueText: Math.round(value)

                onValueChanged: Quran.translationFontSize = Math.round(value)

                Component.onCompleted: {
                    value = Quran.translationFontSize
                }
            }

            TextSwitch {
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

            Label {
                id: fontColorLabel
                anchors {
                    left: parent.left
                    right: parent.right
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                text: qsTr("Font Color")
                visible: Quran.useBackground
            }

            ColorPicker {
                id: fontColorPicker
                anchors {
                    left: parent.left
                    right: parent.right
                }
                columns: 5
                height: width/5
                colors: Quran.useBackground ? ["black", "darkblue", "darkred", "darkgreen", "gray"] : ["white", "darkblue", "darkred", "darkgreen", "gray"]

                onColorChanged: Quran.fontColor = color
                visible: Quran.useBackground
            }
        }
    }
}
