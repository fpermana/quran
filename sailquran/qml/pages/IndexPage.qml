import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: indexPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

    property int suraId

    SilicaListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.indexModel
        currentIndex: suraId

        header: Item {
            id: header
            height: constant.headerHeight
            width: parent.width
            anchors {
                right: parent.right
                rightMargin: constant.paddingMedium
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
                text: "Index"
            }
        }

        delegate: BackgroundItem {
            id: listItem
            height: 80
            width: indexView.width

            Label {
                id: numberLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: parent.height
                width: 50
                anchors {
                    right: parent.right
                    rightMargin: constant.paddingMedium
                    leftMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: Number(model.id).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
//                font { pixelSize: constant.fontSizeXLarge; family: constant.largeFontName; }
//                LayoutMirroring.enabled: true
            }

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: parent.height
                width: 150
                anchors {
                    right: numberLabel.left
                    rightMargin: constant.paddingMedium
                    leftMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.name
//                font { pixelSize: constant.fontSizeXLarge; family: constant.largeFontName; }
//                LayoutMirroring.enabled: true
            }

            Label {
                id: nameLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: parent.height
                anchors {
                    right: textLabel.left
                }

                wrapMode: Text.WordWrap
                text: model.tname
            }

            onClicked: {
                Controller.openSura(model.id)
                pageStack.pop()
            }
        }
    }
}
