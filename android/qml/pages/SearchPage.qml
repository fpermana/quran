import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0
import "../../js/utils.js" as Utils

Page {
    id: page
    title: qsTr("Search")

    property string keyword
    property AyaList ayaList

    Connections {
        target: Searching
        onFoundMore: {
            page.ayaList.addAyaList(ayas);
        }
        onFoundNew: {
            page.keyword = keyword
            page.ayaList = ayaList
        }
    }

    footer: Item {
        height: constant.footerHeight

        anchors {
            left: parent.left
            right: parent.right
        }

        ToolButton {
            id: pageIcon
            height: 30
            icon.source: "qrc:/icons/search_icon.svg"
            anchors {
                right: parent.right
                margins: 10
                verticalCenter: parent.verticalCenter
            }
            onClicked: {
                searchMenu.keyword = page.keyword
                searchMenu.open()
            }
        }
    }
    header: Item {
        height: constant.headerHeight
        Label {
            text: qsTr("Search result for ") + "\"<span style=\"background-color: #FFFF00\">" + page.keyword + "</span>\""
            font.pixelSize: Quran.translationFontSize
            anchors.centerIn: parent
            textFormat: Text.RichText
        }
    }

    Drawer {
        id: searchMenu
        property alias keyword: searchTextField.text

        width: applicationWindow.width
        height: applicationWindow.height * 0.4
        edge: Qt.BottomEdge
        bottomInset: -20

        background: Rectangle {
            radius: 20
        }

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            Label {
                text: qsTr("Search in translations...")
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: searchTextField
                width: 300
                anchors.horizontalCenter: parent.horizontalCenter
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
//                placeholderText: "Find in translations..."
            }

            Button {
                text: qsTr("OK")
                anchors.horizontalCenter: parent.horizontalCenter
                width: 300
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }

                onClicked: {
                    Searching.searchNew(searchTextField.text, Quran.quranText, Quran.translation, 0, 20)
                    searchMenu.close()
                }
            }
        }
    }

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
                    Searching.searchMore(keyword,Quran.quranText,Quran.translation,1,10,lastItem.number)
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
//                    console.log(model.aya)
                contextMenu.open()
            }

            Drawer {
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
            }
        }
    }
}
