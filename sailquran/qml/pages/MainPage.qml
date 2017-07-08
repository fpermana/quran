import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: false

    SilicaListView {
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

        delegate: SilicaListView {
            id: pageView
            property int delegatePage: (index+1)
            property string color: "red"
            height: mainView.height
            width: mainView.width
            focus: true
//            model: Controller.getPageModel(delegateIndex+1);
            model: {
                if(delegatePage == Controller.currentPage-1 || delegatePage == Controller.currentPage || delegatePage == Controller.currentPage+1) {
                    if(delegatePage == Controller.currentPage-1)
                        Controller.firstPage
                    else if(delegatePage == Controller.currentPage)
                        Controller.midPage
                    else if(delegatePage == Controller.currentPage+1)
                        Controller.lastPage
                }
            }
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
        }
    }
}
