import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"

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
                text: "Manage Translations"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("TranslationsPage.qml"));
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
                    text: "Settings"
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
                            font { pixelSize: Settings.fontSize; family: constant.fontName }
                        }
                        Label {
                            id: translationLabel
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignJustify
                            color: Settings.fontColor
                            visible: Settings.useTranslation
                            height: visible ? (paintedHeight + constant.paddingMedium) : 0
                            anchors {
                                top: textLabel.bottom
                                left: parent.left
                                right: parent.right
                                leftMargin: constant.paddingMedium
                                rightMargin: constant.paddingMedium
                            }

                            wrapMode: Text.WordWrap
                            text: model.translation
                            font { pixelSize: Settings.translationFontSize; }
                        }
                    }
                }
            }

            ComboBox {
                id: textStyleCombobox
                anchors {
                    left: parent.left
                    right: parent.right
                }

                label: "Text Style"

                menu: ContextMenu {
                    MenuItem {
                        text: "Original"
                        onClicked: {
                            settingPage.textType = "quran_text_original";
                            Controller.preview.textType = textType;
                            Controller.preview.refresh()
                        }
                    }
                    MenuItem {
                        text: "Enhanced"
                        onClicked: {
                            settingPage.textType = "quran_text_enhanced";
                            Controller.preview.textType = textType;
                            Controller.preview.refresh()
                        }
                    }
                    MenuItem {
                        text: "Uthmani"
                        onClicked: {
                            settingPage.textType = "quran_text_uthmani";
                            Controller.preview.textType = textType;
                            Controller.preview.refresh()
                        }
                    }
    //                MenuItem { text: "Simplified" }
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

            Slider {
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
            }
            TextSwitch {
                id: useTranslationSwitch
                text: "Use Translation"
                checked: Settings.useTranslation
                anchors {
                    left: parent.left
                    right: parent.right
                }
                onCheckedChanged: {
                    Settings.useTranslation = checked
                }
            }

            ComboBox {
                id: translationCombobox
                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: Settings.useTranslation
                label: "Translation"
                menu: ContextMenu {
                    Repeater {
                        id: translationRepeater
                        model: Controller.activeTranslationModel
                        IconMenuItem {
                            property string tid: model.tid
                            text: model.name + ( (translationRepeater.count>5 && model.name !== model.lang) ? (" " + model.lang) : "" );
//                            text: model.name
                            icon: "qrc:/flags/" + model.flag + ".png"

                            onClicked: {
                                var translation = tid;
                                translation = translation.replace(".", "_");
                                settingPage.translation = translation;

                                Controller.preview.translation = translation;
                                Controller.preview.refresh()
//                                console.log(model.iso6391 + "-" + model.flag.toUpperCase())
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    var itemCount = translationRepeater.count
                    for(var i=0; i<itemCount; i++) {
                        var cit = translationRepeater.itemAt(i);
                        var tid = cit.tid;
                        tid = tid.replace(".", "_");
    //                    console.log(tid + " " + Settings.translation)
                        if(tid === Settings.translation) {
                            currentIndex = i;
                            break;
                        }
                    }
                }

                Connections {
                    target: Controller
                    onTranslationChanged: {
                        var itemCount = translationRepeater.count
                        for(var i=0; i<itemCount; i++) {
                            var cit = translationRepeater.itemAt(i);
                            var tid = cit.tid;
                            tid = tid.replace(".", "_");
        //                    console.log(tid + " " + Settings.translation)
                            if(tid === Settings.translation) {
                                translationCombobox.currentIndex = i;
                                break;
                            }
                        }
                    }
                }
                onCurrentIndexChanged: {
                    console.log(currentIndex)
                }
            }

            Slider {
                id: translationFontSizeSlider
                anchors {
                    left: parent.left
                    right: parent.right
                }
                visible: Settings.useTranslation
                label: "Translation Font Size"
                minimumValue: 15
                maximumValue: 35
    //            value: 20
                valueText: Math.round(value)

                onValueChanged: Settings.translationFontSize = Math.round(value)

                Component.onCompleted: {
                    value = Settings.translationFontSize
                }
            }

            TextSwitch {
                id: useBackgroundSwitch
                text: "Use Background"
                checked: Settings.useBackground
                anchors {
                    left: parent.left
                    right: parent.right
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
            }
        }
    }
}
