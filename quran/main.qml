import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    /*SwipeView {
        id: swipeView
        anchors.fill: parent
//        currentIndex: tabBar.currentIndex
        onCurrentIndexChanged: console.log("changed")

        Page1 {
        }

        Page {
            Label {
                text: qsTr("Second page")
                anchors.centerIn: parent
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }*/

    ListView {
        id: mainView
        property int xposition: -1
        objectName: "mainView"
//        focus: true
        anchors.fill: parent
        model: Controller.pages
        layoutDirection: Qt.RightToLeft
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal
        Component.onCompleted: {
            currentIndex = Controller.currentPage-1
            positionViewAtIndex(Controller.currentPage-1, ListView.Beginning)
        }
        /*delegate: Rectangle {
            color: "blue"
            height: mainView.height
            width: mainView.width
            Text {
                text: model.modelData
                anchors.centerIn: parent
            }
//            Component.onCompleted: console.log("Component.onCompleted")
//            Component.onDestruction: console.log("Component.onDestruction")
        }*/
        /*delegate: Item {
            property int delegateIndex: index
            height: mainView.height
            width: mainView.width
            Rectangle {
                height: 200
                width: 200
                anchors.centerIn: parent
                color:"gray"

                Text {
                    text: qsTr("TEXT ") + delegateIndex
                    anchors.centerIn: parent
                }
            }
        }*/

        /*onFlickStarted: {
            xposition = contentX
        }
        onFlickEnded: {
            if(xposition < contentX) {
                Controller.previosPage();
                currentIndex--
            }
            else if(xposition > contentX) {
                Controller.nextPage();
                currentIndex++
            }
        }*/

        delegate: ListView {
            property int delegateIndex: index
            property string color: ListView.isCurrentItem ? "blue" : "red"
            id: pageView
            height: mainView.height
            width: mainView.width
            focus: true
            model: Controller.getPageModel(index+1);
            /*model: {
                if(delegateIndex == mainView.currentIndex || delegateIndex == mainView.currentIndex-1 || delegateIndex == mainView.currentIndex+1) {
                    if(delegateIndex % 3 == 0)
                        Controller.firstPage
                    else if(delegateIndex % 3 == 1)
                        Controller.midPage
                    else if(delegateIndex % 3 == 2)
                        Controller.lastPage
                }
            }*/
            delegate: Rectangle {
                    color: pageView.color
                    height: 80
                    width: pageView.width
                Text {
                    text: model.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    font { family: lateef.name; pixelSize: 16; bold: true }
                    wrapMode: Text.WordWrap
                }
            }
            Component.onCompleted: {

            }
        }
    }
}
