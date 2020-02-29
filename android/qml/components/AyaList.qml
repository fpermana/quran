import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0

ListView {
    id: listView
    property alias page: paging.page
    property alias quranText: paging.quranText
    property alias translation: paging.translation

    onMovementEnded: {
//                        console.log(contentY)
//                        console.log(listView.indexAt(0,contentY))
//                        console.log(listView.itemAt(0,contentY).suraName)
//                        console.log(listView.currentIndex)
//                        console.log(listView.currentSection)
    }
    snapMode: ListView.SnapOneItem

    Paging {
        id: paging
        /*page: (index+1)
        quranText: Quran.quranText
        translation: Quran.translation*/
    }
    spacing: 5

    Connections {
        target: Quran
        onTranslationChanged: {
            paging.translation = translation
        }
        onQuranTextChanged: {
            paging.quranText = quranText
        }
    }

    clip: true
    model: paging.ayaList

    delegate: Item {
        height: childrenRect.height
        width: parent.width
        property int sura: model.sura
        property string suraName: model.suraName
        Label {
            id: bismillahLabel
            visible: (model.aya === 1 && model.sura !== 1)
            text: (Quran.bismillah !== null ? Quran.bismillah.text : "")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: constant.paddingMedium
            }

            font { family: constant.largeFontName; pixelSize: constant.fontSizeHuge; }
            color: Quran.fontColor
            wrapMode: Text.WordWrap
            height: visible ? (paintedHeight + constant.paddingMedium) : 0
        }
        ItemDelegate {
            id: listItem
            height: textLabel.height + translationLabel.height + 20
            anchors {
                top: bismillahLabel.bottom
                left: parent.left
                right: parent.right
            }

            background: Rectangle {
                color: listItem.pressed ? constant.colorHighlightedBackground : "transparent"
            }

            Label {
                id: textLabel
                verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                color: Quran.fontColor
                height: paintedHeight + constant.paddingLarge
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.text + " " + Number(model.aya).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
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
                font.pixelSize: Quran.translationFontSize
//                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                visible: (Quran.useTranslation)
            }
            onClicked: {
                console.log(model.aya)
                contextMenu.open()
//                            contextMenu.show(listItem)
                //contextMenu.state = "visible"
            }

            Drawer {
                id: contextMenu
                width: applicationWindow.width
                height: applicationWindow.height * 0.33
                edge: Qt.BottomEdge
                bottomInset: -20

                background: Rectangle {
                    radius: 20
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 10

                    ItemDelegate {
                        id: menuItem
                        text: qsTr("Bookmark")
                        font.pixelSize: constant.fontSizeMedium
                        width: parent.width
                        onClicked: {
                            contextMenu.close()
                        }

                        background: Rectangle {
                            color: menuItem.pressed ? constant.colorHighlightedBackground : "transparent"
                        }

                        contentItem: Label {
                            text: parent.text
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
