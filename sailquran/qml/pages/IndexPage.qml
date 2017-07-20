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
        delegate: BackgroundItem {
            id: listItem
            height: textLabel.contentHeight + 40
            width: indexView.width

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
                color: model.id === indexPage.suraId ? constant.colorHighlighted : constant.colorLight
                height: paintedHeight + constant.paddingLarge
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: Number(model.id).toLocaleString(Qt.locale("ar-SA"), 'd', 0) + "\t" + model.name
                font { pixelSize: constant.fontSizeXLarge; family: constant.largeFontName; }
                LayoutMirroring.enabled: true
            }
        }
            /*Label {
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
                text: Number(model.id).toLocaleString(Qt.locale("ar-SA"), 'd', 0) + "\t" + model.name
                font { pixelSize: constant.fontSizeXLarge; family: constant.largeFontName; }
                LayoutMirroring.enabled: true
            }*/
        /*visibleArea.onXPositionChanged: {
            if(loaded) {
                var p = Math.round(Controller.pages - Controller.pages * visibleArea.xPosition)
                if(p == Controller.currentPage-1 || p == Controller.currentPage+1)
                    Controller.currentPage = p
            }
        }*/
    }
}
