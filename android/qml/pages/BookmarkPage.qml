import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0
import "../../js/utils.js" as Utils

Page {
    id: page
    title: qsTr("Bookmark")

    property AyaList ayaList

    Component.onCompleted: {
        Bookmarking.getBookmarkList(Quran.quranText, Quran.translation);
    }

    Connections {
        target: Bookmarking
        onLoaded: {
            page.ayaList = ayaList;
        }
        onLoadedMore: {
            page.ayaList.addAyaList(ayas);
        }
    }

    /*header: Item {
        height: constant.headerHeight
        Label {
            text: qsTr("Bookmarks")
            font.pixelSize: Quran.translationFontSize
            anchors.centerIn: parent
        }
    }*/

    Rectangle {
        anchors.fill: listView
        color: Quran.backgroundColor
        visible: Quran.useBackground
    }

    ListView {
        id: listView
        snapMode: ListView.SnapOneItem
        spacing: 5

        anchors.fill: parent

        onAtYEndChanged: {
            if(atYEnd && ayaList !== null) {
                var lastItem = ayaList.get(count-1)
                if(lastItem !== null)
                    Bookmarking.loadMoreBookmarkList(Quran.quranText,Quran.translation,lastItem.number)
            }
        }

        clip: true
        model: ayaList

        delegate: ItemDelegate {
            height: suraLabel.height + textLabel.height + translationLabel.height + 20
            width: parent.width

            background: Rectangle {
                color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
            }
            Label {
                id: numberLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: Quran.fontColor
                height: suraLabel.height
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.horizontalCenter
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: "("+(index+1)+")"
//                font { pixelSize: Quran.fontSize; family: constant.fontName; }
                LayoutMirroring.enabled: false
            }

            Label {
                id: suraLabel
                verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                color: Quran.fontColor
                height: paintedHeight + constant.paddingLarge
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.horizontalCenter
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.suraName
                font { pixelSize: Quran.fontSize; family: constant.fontName; }
                LayoutMirroring.enabled: true
            }

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                color: Quran.fontColor
                height: paintedHeight + constant.paddingLarge
                anchors {
                    top: suraLabel.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.text + " " + Utils.reverseString(Number(model.aya).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                font { pixelSize: Quran.fontSize; family: constant.fontName; }
                LayoutMirroring.enabled: true
            }
            Label {
                id: translationLabel
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignJustify
                color: Quran.fontColor
                height: visible ? (paintedHeight + constant.paddingMedium) : 0
                anchors {
                    top: textLabel.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.translation
                textFormat: Text.RichText
                font.pixelSize: Quran.translationFontSize
//                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                visible: (Quran.useTranslation)
            }
            Rectangle {
                anchors {
                    top: translationLabel.bottom
                    left: parent.left
                    right: parent.right
                }
                height: 2
                color: "gray"
            }

            onClicked: {

            }

            /*Drawer {
                id: contextMenu
                width: applicationWindow.width
                height: childrenRect.height + 100
                edge: Qt.BottomEdge
                bottomInset: -20

                background: Rectangle {
                    radius: 20
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 20

                    Label {
                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                        color: Quran.fontColor
                        height: paintedHeight + constant.paddingLarge
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: constant.paddingMedium
                            rightMargin: constant.paddingMedium
                        }

                        wrapMode: Text.WordWrap
                        text: model.text + " " + Utils.reverseString(Number(model.aya).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                        font { pixelSize: Quran.fontSize; family: constant.fontName; }
                        LayoutMirroring.enabled: true
                    }
                    Label {
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignJustify
                        color: Quran.fontColor
                        height: visible ? (paintedHeight + constant.paddingMedium) : 0
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: constant.paddingMedium
                            rightMargin: constant.paddingMedium
                        }

                        wrapMode: Text.WordWrap
                        text: model.translation
                        font.pixelSize: Quran.translationFontSize
    //                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                        visible: (Quran.useTranslation)
                    }

                    Button {
                        text: qsTr("Bookmark")
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 300
                        onClicked: {
                        }
                    }
                }
            }*/
        }
    }
}
