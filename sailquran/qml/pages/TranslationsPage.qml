import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: translationsPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
//    showNavigationIndicator: false

    SilicaListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.translationModel

        header: Item {
            id: header
            height: constant.headerHeight
            width: indexView.width

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
                text: "Translations"
            }
        }

        delegate: BackgroundItem {
            id: listItem

            property bool menuOpen: contextMenu != null && contextMenu.parent === listItem
            height: (menuOpen ? contextMenu.height : 0) + textLabel.height

            width: indexView.width

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
                font { pixelSize: constant.fontSizeMedium; }
            }

            Component.onCompleted: {
                var isDownloading = Controller.isDownloading(model.tid);
                if(isDownloading) {
                    listItem.enabled = false
                    textLabel.text = "Downloading..."
                }
            }

            onClicked: {
                contextMenu.show(listItem)
            }

            ContextMenu {
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
            }

            RemorseItem { id: remorse }
        }
    }
}
