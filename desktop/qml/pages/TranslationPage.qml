import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Universal 2.12
import id.fpermana.sailquran 1.0
import "../components" as Comp

Page {
    id: root
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

    Popup {
        id: uninstallDialog

        property string tid

        width: Math.min(220, root.width/2)
        dim: true
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        modal: true
        parent: Overlay.overlay

        Column {
            height: childrenRect.height
            anchors {
                left: parent.left
                right: parent.right
            }

            Comp.Label {
                text: "Uninstall Translation?"
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }
            Row {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                ToolButton {
                    text: "Yes"
                    width: parent.width/2
                    onClicked: {
                        Translation.uninstallTranslation(uninstallDialog.tid)
                        uninstallDialog.close()
                    }
                }

                ToolButton {
                    text: "No"
                    width: parent.width/2
                    onClicked: uninstallDialog.close()
                }
            }
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

            property bool isInstalled: model.installed

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

            Comp.Label {
                id: textLabel
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
                color: model.isDefault ? Universal.color(Universal.Green) : (isInstalled ? Universal.color(Universal.Emerald) : (listItem.enabled ? Universal.foreground : Universal.color(Universal.Steel)))
            }

            Component.onCompleted: {
                var status = Translation.getStatus(model.tid);
                if(status === 1) {
                    listItem.enabled = false
                    textLabel.text = "Waiting..."
                    textLabel.color = Universal.color(Universal.Steel)
                }
                else if(status === 2) {
                    listItem.enabled = false
                    textLabel.text = "Downloading..."
                    textLabel.color = Universal.color(Universal.Steel)
                }
                else if(status === 3) {
                    listItem.enabled = false
                    textLabel.text = "Installing..."
                    textLabel.color = Universal.color(Universal.Steel)
                }
                else if(status === 4) {
                    listItem.enabled = false
                    textLabel.text = "Uninstalling..."
                    textLabel.color = Universal.color(Universal.Steel)
                }
            }

            onClicked: {
                if(!isInstalled) {
                    Translation.installTranslation(model.tid)
                }
                else if(!model.isDefault){
                    console.log(model.isDefault)
                    var tid = model.tid;
                    tid = tid.replace(".", "_");
                    if(tid !== Quran.translation) {
                        uninstallDialog.tid = model.tid
                        uninstallDialog.open()
                    }
                }
            }

            Connections {
                target: Translation
                onStatusChanged: {
                    if(model.tid === tid) {
                        if(status === 1) {
                            listItem.enabled = false
                            textLabel.text = "Waiting..."
                            textLabel.color = Universal.color(Universal.Steel)
                        }
                        else if(status === 2) {
                            listItem.enabled = false
                            textLabel.text = "Downloading..."
                            textLabel.color = Universal.color(Universal.Steel)
                        }
                        else if(status === 3) {
                            listItem.enabled = false
                            textLabel.text = "Installing..."
                            textLabel.color = Universal.color(Universal.Steel)
                        }
                        else if(status === 4) {
                            listItem.enabled = false
                            textLabel.text = "Uninstalling..."
                            textLabel.color = Universal.color(Universal.Steel)
                        }
                        else if(status === 5) {
                            listItem.isInstalled = true
                            listItem.enabled = true
                            textLabel.text = model.name
                            textLabel.color = Universal.color(Universal.Emerald)
                        }
                        else if(status === 6) {
                            listItem.isInstalled = false
                            listItem.enabled = true
                            textLabel.text = model.name
                            textLabel.color = Universal.foreground
                        }
                    }
                }
            }
        }
    }
}
