import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0

Page {
    id: translationsPage
    title: qsTr("Translation")
    property TranslationList translationList

    Component.onCompleted: {
        Translation.getAllTranslation()
    }

    Connections {
        target: Translation
        onTranslationLoaded: {
            translationList = translation
        }
    }

    ListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: translationList

        delegate: ItemDelegate {
            id: listItem
            height: textLabel.height
            width: indexView.width

            background: Rectangle {
                color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
            }

            Item {
                id: flagImage
                anchors {
                    left: parent.left
                    verticalCenter: textLabel.verticalCenter
                    leftMargin: 10
                }
                height: textLabel.height/3
                width: textLabel.height

                Image {
                    source: "qrc:/flags/" + model.flag + ".png"
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    height: parent.height
                }
            }

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
                height: 80
                anchors {
                    top: parent.top
                    left: flagImage.right
                    right: parent.right
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.name
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
            }

            Component.onCompleted: {
                var status = Translation.getStatus(model.tid);
                if(status === 2) {
                    listItem.enabled = false
                    textLabel.text = "Downloading..."
                }
                else if(status === 3) {
                    listItem.enabled = false
                    textLabel.text = "Installing..."
                }
            }

            onClicked: {
//                contextMenu.show(listItem)
                if(!model.installed) {
                    textLabel.text = "Downloading..."
                    Translation.installTranslation(model.tid)
                }
            }

            Connections {
                target: Translation
                onTranslationInstalled: {
                    if(model.tid === tid) {
                        textLabel.text = model.name
                        listItem.enabled = true
                    }
                }
            }

            /*ContextMenu {
                id: contextMenu
                MenuItem {
                    text: "Download"
                    onClicked: {
                        listItem.enabled = false
                        textLabel.text = "Downloading..."
                        Controller.downloadTranslation(model.tid);
                    }
                    visible: !model.installed
                }
                MenuItem {
                    text: "Remove"
                    onClicked: {
                        remorse.execute(listItem, "Removing...", function() { Controller.removeTranslation(model.tid); } )
                    }
                    visible: model.installed
                }
            }*/
        }
    }
}
