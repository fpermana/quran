import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property alias title: titleText.text
    property alias description: descriptionText.text

    Column {
        width: parent.width
        anchors.margins: constant.paddingLarge

        DialogHeader {
            acceptText: "Yes"
            cancelText: "No"
        }

        Label {
            id: titleText
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            color: constant.colorLight
            wrapMode: Text.WordWrap
            font { family: constant.fontName; pixelSize: constant.fontSizeLarge; }
            anchors.margins: constant.paddingMedium
        }
        Label {
            id: descriptionText
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: constant.colorLight
            wrapMode: Text.WordWrap
            font { family: constant.fontName; pixelSize: constant.fontSizeSmall; italic: true; }
            anchors.margins: constant.paddingMedium
        }
    }
}
