import QtQuick 2.12
import QtQuick.Controls 2.12
import "." as Comp

ItemDelegate {
    id: root
    implicitHeight: 90
    implicitWidth: 150

    property string title: ""
    property alias model: listView.model
    property string initValue: ""
    property string nameRole: "name"
    property string valueRole: "value"

    signal valueChanged(string value)

    Component.onCompleted: {
        var count = listView.count
        for(var i=0; i<count; i++) {
            if(model.get(i)[valueRole] === initValue) {
                nameLabel.text = model.get(i)[nameRole]
                break
            }
        }
    }

    Image {
        id: image
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: 10
        }
        height: root.height*0.4

        fillMode: Image.PreserveAspectFit
        source: "qrc:/icons/drop_down.svg"
    }

    Comp.Label {
        id: titleLabel
        text: root.title
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.verticalCenter
            leftMargin: 15
            rightMargin: 15
        }
        horizontalAlignment: Text.AlignLeft
    }

    Comp.Label {
        id: nameLabel
        text: "Value"
        color: "gray"
        anchors {
            top: parent.verticalCenter
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 15
            rightMargin: 15
        }
        horizontalAlignment: Text.AlignLeft
    }


    Drawer {
        id: options
        width: applicationWindow.width
        height: applicationWindow.height * 0.4
        edge: Qt.BottomEdge
        bottomInset: -20

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 20

            header: Comp.Label {
                text: root.title
                width: listView.width
                height: 60
                font.pixelSize: constant.fontSizeLarge
            }

            delegate: ItemDelegate {
                width: listView.width
                height: 60
                Comp.Label {
                    text: model[nameRole]
                    anchors.fill: parent
                }

                onClicked: {
                    nameLabel.text = model[nameRole]
                    valueChanged(model[valueRole])
                    options.close()
                }
            }
        }
    }

    onClicked: {
        if(listView.count > 3) {
            options.width = applicationWindow.width * 0.4
            options.height = applicationWindow.height
            options.edge = Qt.LeftEdge
            options.leftInset = -20
        } else {
            options.width = applicationWindow.width
            options.height = applicationWindow.height * 0.4
            options.edge = Qt.BottomEdge
            options.bottomInset = -20
        }

        options.open()
    }
}
