import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
//import QuranQuick 1.0

ApplicationWindow {
    visible: true
    minimumHeight: 768
    minimumWidth: 1024
    title: qsTr("Hello World")

    QtObject {
        id: constant

        property int headerHeight: 80
        property int paddingMedium: 10
        property int paddingSmall: 5
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
//        currentIndex: tabBar.currentIndex
        onCurrentIndexChanged: console.log("changed")
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
    }
}
