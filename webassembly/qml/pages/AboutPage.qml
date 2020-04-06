import QtQuick 2.12
import QtQuick.Controls 2.5
import "../components" as Comp

Comp.Page {
    id: aboutPage
    title: qsTr("About")

    ListModel {
        id: detailModel

        ListElement {
            title: "Application License"
            detail: "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2 of the License.<br />This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.<br />You should have received a copy of the GNU General Public License along with this program; if not, see <a href=\"http://www.gnu.org/licenses\">http://www.gnu.org/licenses</a>."
        }

        ListElement {
            title: "Tanzil.net license"
            detail: "Enhanced and Uthmani text are from Tanzil Quran Text.<br />Copyright © 2008-2010 Tanzil.net<br />License: Creative Commons Attribution 3.0<br /><br />This copy of quran text is carefully produced, highly verified and continuously monitored by a group of specialists at Tanzil project.<br /><br />TERMS OF USE:<br />Permission is granted to copy and distribute verbatim copies of this text, but CHANGING IT IS NOT ALLOWED.<br />This quran text can be used in any website or application, provided its source (Tanzil.net) is clearly indicated, and a link is made to http://tanzil.net to enable users to keep track of changes.<br />This copyright notice shall be included in all verbatim copies of the text, and shall be reproduced appropriately in all files derived from or containing substantial portion of this text.<br />Please check updates at: <a href=\"http://tanzil.net/updates/\">http://tanzil.net/updates/</a>"
        }

        ListElement {
            title: "Qurandatabase.org"
            detail: "Original text is from qurandatabase.org.<br /><br />This copy of quran text is produced and monitored by qurandatabase.org. This quran text is free for download from <a href=\"http://www.qurandatabase.org/\">http://www.qurandatabase.org/</a> and can be used in any website or application. Any important changes will be informed to the author of website or application."
        }

        ListElement {
            title: "Translations license"
            detail: "The translations provided are for non-commercial purposes only. If used otherwise, you need to obtain necessary permission from translator or the publisher. Translations are being downloaded from <a href=\"http://tanzil.net/trans\">http://tanzil.net/trans</a>"
        }
    }

    ListView {
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
                    source: "qrc:/icons/quran.png"
                    anchors.horizontalCenter: parent.horizontalCenter

                    sourceSize.width: parent.width/5
                    horizontalAlignment: Image.AlignHCenter
                    fillMode: Image.PreserveAspectFit
                }

                Comp.Label {
                    text: "SailQuran Version 0.3"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    font { pixelSize: constant.fontSizeXLarge; bold: true }
                }

                Comp.Label {
                    text: "Copyright © Fandy Permana 2020"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }

                Component.onCompleted: {
                    anchors.verticalCenter = parent.verticalCenter
                }
            }
        }

        model: detailModel

        delegate: ItemDelegate {
            width: detailListView.width
            height: contentColumn.height + 30
            Column {
                id: contentColumn
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 20
                }

                /*Component.onCompleted: {
                    anchors.verticalCenter = parent.verticalCenter
                }*/

                Comp.Label {
                    text: qsTr(model.title)
                    font { pixelSize: constant.fontSizeLarge; bold: true }
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    height: paintedHeight + 15
                }
                Comp.Label {
                    text: qsTr(model.detail)
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignJustify
                    height: paintedHeight + 15
//                    textFormat: Text.RichText
                }
            }
        }
    }
}
