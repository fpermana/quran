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
                if(!model.isDefault)
                    contextMenu.open(listItem)
            }

            Connections {
                target: Translation
                onTranslationInstalled: {
                    if(model.tid === tid) {
                        textLabel.text = model.name
                        listItem.enabled = true
                        downloadMenu.visible = false
                        removeMenu.visible = true
                    }
                }
                onTranslationUninstalled: {
                    if(model.tid === tid) {
                        downloadMenu.visible = true
                        removeMenu.visible = false
                    }
                }
            }

            ContextMenu {
                id: contextMenu
                MenuItem {
                    id: downloadMenu
                    text: qsTr("Download")
                    onClicked: {
                        listItem.enabled = false
                        textLabel.text = "Downloading..."
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
                            remorse.execute(listItem, "Removing...", function() {
                                Translation.uninstallTranslation(model.tid);
                            })
                        }
                    }
                    visible: model.installed && !model.isDefault
                }
            }

            RemorseItem { id: remorse }
        }
    }
}
