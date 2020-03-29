import QtQuick 2.0

Item {
    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.fill: parent

        Image {
            id: image
            x: 392
            width: 100
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            fillMode: Image.PreserveAspectFit
            source: "qrc:/icons/drop_down.svg"
        }

        Row {
            id: row
            anchors.right: image.left
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10

            Text {
                id: element
                text: qsTr("Text")
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 12
            }

            Text {
                id: element1
                text: qsTr("Text")
                opacity: 1
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 12
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:500}D{i:2;anchors_height:100;anchors_y:0}D{i:3;anchors_height:400;anchors_width:200;anchors_x:76;anchors_y:15}
D{i:1;anchors_height:200;anchors_width:200;anchors_x:186;anchors_y:163}
}
##^##*/
