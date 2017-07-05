import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: page
//    allowedOrientations: Orientation.All
    height: mainView.height; width: mainView.width
    Rectangle {
        color: "white"
        height: 200
        width: 200
        anchors.centerIn: parent
    }
}
