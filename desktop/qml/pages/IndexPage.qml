import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id: indexPage
    title: qsTr("Index")

    property alias currentIndex: indexView.currentIndex

    ListView {
        id: indexView
        objectName: "indexView"
        anchors.fill: parent
        model: Quran.suraList
//        snapMode: ListView.SnapOneItem
//        currentIndex: suraId

        /*header: Item {
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
                color: constant.colorLight
                wrapMode: Text.WordWrap
                text: qsTr("Index")
            }
        }*/

        delegate: ItemDelegate {
            height: 80
            width: indexView.width

            background: Rectangle {
                color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
            }

            Label {
                id: numberLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
//                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: parent.height
                width: 50
                anchors {
                    right: parent.right
                    rightMargin: constant.paddingMedium
                    leftMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: Number(model.number).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
                font { pixelSize: constant.fontSizeLarge; family: constant.largeFontName; }
            }

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
//                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: parent.height
                width: 150
                anchors {
                    right: numberLabel.left
                    rightMargin: constant.paddingMedium
                    leftMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.name
                font { pixelSize: constant.fontSizeLarge; family: constant.largeFontName; }
            }

            Label {
                id: nameLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
//                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: parent.height
                anchors {
                    right: textLabel.left
                }

                wrapMode: Text.WordWrap
                text: model.tname
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
            }

            onClicked: {
                Quran.openSura(model.number)
            }
        }
    }
}
