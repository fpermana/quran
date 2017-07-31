import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: aboutPage
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

    ListModel {
        id: detailModel

        ListElement {
            title: "Contributors"
            detail: "Icon by Hariyanto Wibowo"
        }

        ListElement {
            title: "Application License"
            detail: "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2 of the License.\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\nYou should have received a copy of the GNU General Public License along with this program; if not, see http://www.gnu.org/licenses."
        }

        ListElement {
            title: "License for style text"
            detail: "Enhanced and Uthmani text are from Tanzil Quran Text\nCopyright © 2008-2010 Tanzil.net\nLicense: Creative Commons Attribution 3.0\n\nThis copy of quran text is carefully produced, highly verified and continuously monitored by a group of specialists at Tanzil project.\n\nTERMS OF USE:\nPermission is granted to copy and distribute verbatim copies of this text, but CHANGING IT IS NOT ALLOWED.\nThis quran text can be used in any website or application, provided its source (Tanzil.net) is clearly indicated, and a link is made to http://tanzil.net to enable users to keep track of changes.\nThis copyright notice shall be included in all verbatim copies of the text, and shall be reproduced appropriately in all files derived from or containing substantial portion of this text.\nPlease check updates at: http://tanzil.net/updates/\n\n\nOriginal text is generated from www.qurandatabase.org\nCopyright © www.qurandatabase.org"
        }

        ListElement {
            title: "Translations license"
            detail: "The translations provided are for non-commercial purposes only. If used otherwise, you need to obtain necessary permission from translator or the publisher. Translations are being downloaded from http://tanzil.net/trans"
        }
    }

    SilicaListView {
        id: detailListView
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
                    text: "Simple Quran Reader Version 0.1"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font { pixelSize: constant.fontSizeLarge; }
                }

                Label {
                    text: "Copyright © Fandy Permana 2017"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font { pixelSize: constant.fontSizeMedium; }
                }

                Component.onCompleted: {
                    anchors.verticalCenter = parent.verticalCenter
                }
            }
        }

        model: detailModel

        delegate: BackgroundItem {
            width: detailListView.width
            height: contentColumn.height + 20
            Column {
                id: contentColumn
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Component.onCompleted: {
                    anchors.verticalCenter = parent.verticalCenter
                }

                Label {
                    text: model.title
                    font { pixelSize: constant.fontSizeMedium; bold: true }
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Label {
                    text: model.detail
                    font { pixelSize: constant.fontSizeMedium; }
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
