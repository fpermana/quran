import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: settingPage
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

        ComboBox {
            id: textStyleCombobox
            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
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
