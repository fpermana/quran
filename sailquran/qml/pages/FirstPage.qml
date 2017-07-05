import QtQuick 2.1
import Sailfish.Silica 1.0

Item {
    id: page
//    allowedOrientations: Orientation.All
    height: mainView.height; width: mainView.width
    Rectangle {
        color: "red"
        height: 200
        width: 200
        anchors.centerIn: parent
    }

    Text {
        id: name
        text: qsTr("TEXT")
        height: 100
        width: 100
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
