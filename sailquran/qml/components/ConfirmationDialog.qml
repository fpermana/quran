import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property alias title: titleText.text
    property alias description: descriptionText.text

    Column {
        width: parent.width

        DialogHeader {
            acceptText: "Yes"
            cancelText: "No"
        }

        Text {
            id: titleText
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            color: constant.colorLight
            wrapMode: Text.WordWrap
            font { family: constant.fontName; pixelSize: constant.fontSizeXLarge; }
        }
        Text {
            id: descriptionText
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: constant.colorLight
            wrapMode: Text.WordWrap
            font { family: constant.fontName; pixelSize: constant.fontSizeMedium; }
        }
    }
}
