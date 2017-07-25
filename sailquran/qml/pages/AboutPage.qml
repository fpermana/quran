import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: aboutPage
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

//    Flickable {
//        anchors.fill: parent
//    }

    ListModel {
        id: detailModel

        ListElement {
            title: "Contributors"
            detail: ""
        }

        ListElement {
            title: "Application License"
            detail: ""
        }

        ListElement {
            title: "License for simplified text"
            detail: ""
        }

        ListElement {
            title: "Translations license"
            detail: ""
        }
    }

    SilicaListView {
        anchors.fill: parent
        header: Item {
            width: aboutPage.width
            height: childrenRect.height + 60
            Column {
                spacing: 10
                height: childrenRect.height
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Image {
                    id: iconImage
                    source: "qrc:/icons/quran.svg"
                    anchors.horizontalCenter: parent.horizontalCenter

                    sourceSize.width: parent.width/3
                    horizontalAlignment: Image.AlignHCenter
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Copyright"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font { family: constant.fontName; pixelSize: constant.fontSizeLarge; }
                }

                Component.onCompleted: {
                    anchors.verticalCenter = parent.verticalCenter
                }
            }
        }
    }
}
