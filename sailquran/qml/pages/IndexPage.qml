import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: indexPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

    property int suraId

    SilicaListView {
        id: indexView
        objectName: "indexView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.indexModel
        currentIndex: suraId

        delegate: BackgroundItem {
            id: listItem
            height: textLabel.height + 40
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

            onClicked: {
                Controller.openSura(model.id)
                pageStack.pop()
            }
        }
    }
}
