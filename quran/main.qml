import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    FontLoader { id: lateef; source: "qrc:/fonts/LateefRegOT.ttf" }

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
        objectName: "mainView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.pages
        layoutDirection: Qt.RightToLeft
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal
        Component.onCompleted: {
            positionViewAtIndex(Controller.currentPage-1, ListView.Beginning);
            loaded = true
        }
        visibleArea.onXPositionChanged: {
            if(loaded)
                Controller.currentPage = Math.round(Controller.pages - Controller.pages * visibleArea.xPosition)
        }

        delegate: ListView {
            id: pageView
            property int delegatePage: (index+1)
            property string color: "red"
            height: mainView.height
            width: mainView.width
            focus: true
//            model: Controller.getPageModel(delegateIndex+1);
            model: {
                    if(delegatePage == Controller.currentPage-1)
                        Controller.firstPage
                    else if(delegatePage == Controller.currentPage)
                        Controller.midPage
                    else if(delegatePage == Controller.currentPage+1)
                        Controller.lastPage
            }
            delegate: Rectangle {
                    color: pageView.color
                    height: 80
                    width: pageView.width
                Label {
                    text: model.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    font { family: lateef.name; pixelSize: Theme.fontSizeMedium; }
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                }

                /*MouseArea {
                    anchors.fill: parent
                    onClicked: console.log(model.text)
                }*/
            }
        }
    }
}
