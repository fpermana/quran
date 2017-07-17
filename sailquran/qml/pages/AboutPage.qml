import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: indexPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

    property int suraId

    Component.onCompleted: {
    }

    SilicaListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.indexModel
        Component.onCompleted: {
//            positionViewAtIndex(Controller.currentPage-1, ListView.Beginning);
//            loaded = true
        }
        delegate:
            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: paintedHeight + constant.paddingLarge
                width: indexView.width
                anchors {
                    margins: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: Utils.reverseString(Number(model.id).toLocaleString(Qt.locale("ar-SA"), 'd', 0)) + " " + model.name
                font { pixelSize: Settings.fontSize; family: constant.fontName; }
                LayoutMirroring.enabled: true
            }
        /*visibleArea.onXPositionChanged: {
            if(loaded) {
                var p = Math.round(Controller.pages - Controller.pages * visibleArea.xPosition)
                if(p == Controller.currentPage-1 || p == Controller.currentPage+1)
                    Controller.currentPage = p
            }
        }*/
    }
}
