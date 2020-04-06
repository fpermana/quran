import QtQuick 2.12
import QtQuick.Controls 2.5
import "../js/utils.js" as Utils
import "../components" as Comp

Comp.Page {
    id: indexPage
    title: qsTr("Index")

    property alias currentIndex: indexView.currentIndex

    ListView {
        id: indexView
        objectName: "indexView"
        anchors.fill: parent
        model: Quran.suraList

        delegate: ItemDelegate {
            height: 80
            width: indexView.width

            Comp.Label {
                id: numberLabel
                horizontalAlignment: Text.AlignRight
                height: parent.height
                width: parent.width * 0.2
                anchors {
                    right: parent.right
                    rightMargin: constant.paddingMedium
                    leftMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: Utils.reverseString(Number(model.number).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                font { pixelSize: Quran.fontSize+8; family: Quran.largeFontName; }
            }

            Comp.Label {
                id: textLabel
                horizontalAlignment: Text.AlignRight
                height: parent.height
                width: parent.width * 0.35
                anchors {
                    right: numberLabel.left
                    rightMargin: constant.paddingMedium
                    leftMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.name
                font { pixelSize: Quran.fontSize+4; family: Quran.largeFontName; }
            }

            Comp.Label {
                id: nameLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                height: parent.height
                width: parent.width * 0.45
                anchors {
                    right: textLabel.left
                }

                wrapMode: Text.WordWrap
                text: model.tname
                font { pixelSize: Quran.translationFontSize; family: Quran.fontName; }
            }

            onClicked: {
                Quran.openSura(model.number)
            }
        }
    }
}
