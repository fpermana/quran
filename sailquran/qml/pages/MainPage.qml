import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: false

    /*SlideshowView {
        id: mainView
        objectName: "mainView"

        itemWidth: width
        itemHeight: height
//        height: parent.height
        clip:true

//        anchors { top: parent.top; left: parent.left; right: parent.right }
        anchors.fill: parent
        model: VisualItemModel {
            FirstPage {}
            SecondPage {}
            ThirdPage {}
        }
    }*/

    SilicaListView {
        orientation: ListView.Horizontal
        id: mainView
        objectName: "mainView"
        clip:true
        anchors.fill: parent
        model: VisualItemModel {
            FirstPage {}
            SecondPage {}
            ThirdPage {}
        }
        layoutDirection: Qt.RightToLeft
        snapMode: ListView.SnapOneItem
    }
}

