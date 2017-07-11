import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: settingPage
//    onStatusChanged: console.log(settingPage.status)
//    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent

        Item {
            id: header
            height: constant.headerHeight
            width: parent.width
            anchors {
                top: parent.top
                right: parent.right
                margins: constant.paddingMedium
            }

            Label {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }
                verticalAlignment: Text.AlignVCenter
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                text: "Settings"
            }
        }

        SilicaListView {
            id: preview
            height: constant.headerHeight
            focus: true
            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
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
                    color: constant.colorLight
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
                    font { pixelSize: constant.fontSizeLarge; }
                    font.family: constant.fontName
                }
            }
        }

        ComboBox {
            id: textStyleCombobox
            anchors {
                left: parent.left
                right: parent.right
                top: preview.bottom
            }

            label: "Text Style"

            menu: ContextMenu {
                MenuItem { text: "Simplified" }
                MenuItem { text: "Minimal" }
                MenuItem { text: "Enhanced" }
            }

            onCurrentIndexChanged: console.log(currentIndex)
        }
    }
}
