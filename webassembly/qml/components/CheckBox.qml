import QtQuick 2.12
import QtQuick.Controls 2.12
import "." as Comp

CheckBox {
    id: root
    checked: false

    indicator: Rectangle {
        implicitWidth: 24
        implicitHeight: 24
        x: root.leftPadding
        y: parent.height / 2 - height / 2
        radius: 12
//        border.color: root.down ? "#17a81a" : "#21be2b"
        border.color: "black"

        Rectangle {
            width: 12
            height: 12
            x: 6
            y: 6
            radius: 12
//            color: root.down ? "#17a81a" : "#21be2b"
            color: "black"
            visible: root.checked
        }
    }

    contentItem: Comp.Label {
        text: root.text
        opacity: enabled ? 1.0 : 0.3
//        color: root.down ? "#17a81a" : "#21be2b"
//        color: "black"
//        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        leftPadding: root.indicator.width + root.spacing
    }
}
