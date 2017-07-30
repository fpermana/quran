import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: translationsPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

    SilicaListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.translationModel

        delegate: BackgroundItem {
            id: listItem
            height: textLabel.height + 40
            width: indexView.width

            Item {
                id: flagImage
                anchors {
                    left: parent.left
                }
                height: parent.height
                width: parent.height

                Image {
                    source: "qrc:/flags/" + model.flag + ".svg"
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    width: parent.width*3/4
                }
            }

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
                height: paintedHeight + constant.paddingLarge
                anchors {
                    top: parent.top
                    left: flagImage.right
                    right: parent.right
                    margins: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.name
                font { pixelSize: constant.fontSizeMedium; }
            }

            onClicked: {
            }
        }
    }
}
