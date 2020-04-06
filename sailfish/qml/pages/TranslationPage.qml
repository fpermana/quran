import QtQuick 2.0
import Sailfish.Silica 1.0
import id.fpermana.sailquran 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: translationsPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
//    showNavigationIndicator: false
    property TranslationList translationList

    Component.onCompleted: {
        Translation.getAllTranslation()
    }

    Connections {
        target: Translation
        onTranslationLoaded: {
            translationList = translation;
        }
    }

    onStatusChanged: {
        if(translationsPage.status === PageStatus.Deactivating) {
            Translation.getActiveTranslation()
        }
    }

    SilicaListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: translationList

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
                text: qsTr("Translation")
            }
        }

        delegate: BackgroundItem {
            id: listItem

            enabled: !model.isDefault

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
                var status = Translation.getStatus(model.tid);
                if(status === 1) {
                    listItem.enabled = false
                    textLabel.text = "Waiting..."
                }
                else if(status === 2) {
                    listItem.enabled = false
                    textLabel.text = "Downloading..."
                }
                else if(status === 3) {
                    listItem.enabled = false
                    textLabel.text = "Installing..."
                }
                else if(status === 4) {
                    listItem.enabled = false
                    textLabel.text = "Uninstalling..."
                }
            }

            onClicked: {
                if(!model.isDefault)
                    contextMenu.open(listItem)
            }

            Connections {
                target: Translation
                onStatusChanged: {
                    if(model.tid === tid) {
                        if(status === 1) {
                            listItem.enabled = false
                            textLabel.text = "Waiting..."
                        }
                        else if(status === 2) {
                            listItem.enabled = false
                            textLabel.text = "Downloading..."
                        }
                        else if(status === 3) {
                            listItem.enabled = false
                            textLabel.text = "Installing..."
                        }
                        else if(status === 4) {
                            listItem.enabled = false
                            textLabel.text = "Uninstalling..."
                        }
                        else if(status === 5) {
                            removeMenu.visible = true
                            downloadMenu.visible = false
                            listItem.enabled = true
                            textLabel.text = model.name
                        }
                        else if(status === 6) {
                            removeMenu.visible = false
                            downloadMenu.visible = true
                            listItem.enabled = true
                            textLabel.text = model.name
                        }
                    }
                }
            }

            ContextMenu {
                id: contextMenu
                MenuItem {
                    id: downloadMenu
                    text: qsTr("Download")
                    onClicked: {
                        Translation.installTranslation(model.tid);
                    }
                    visible: !model.installed && !model.isDefault
                }
                MenuItem {
                    id: removeMenu
                    text: qsTr("Remove")
                    onClicked: {
                        var tid = model.tid;
                        tid = tid.replace(".", "_");
                        if(tid !== Quran.translation) {
//                            remorse.execute(listItem, "Removing...", function() {
                                Translation.uninstallTranslation(model.tid);
//                            })
                        }
                    }
                    visible: model.installed && !model.isDefault
                }
            }

            RemorseItem { id: remorse }
        }
    }
}
