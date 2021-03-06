import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0
import "../js/utils.js" as Utils
import "../components" as Comp

Comp.Page {
    id: page
    title: qsTr("Search")
    searchable: true

    property string keyword
    property AyaList ayaList

    onSearching: {
        page.keyword = keyword
        Searching.searchNew(keyword, Quran.quranText, Quran.translation, 0, 20)
    }

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

    /*footer: Item {
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
    }*/
    header: Item {
        height: constant.headerHeight
        Comp.Label {
            text: (listView.count > 0 ? qsTr("Search result for ") : qsTr("No result for ")) + "\"<span style=\"background-color: #FFFF00\">" + page.keyword + "</span>\""
            anchors.centerIn: parent
            textFormat: Text.RichText
        }
    }

    /*Drawer {
        id: searchMenu
        property alias keyword: searchTextField.text

        width: applicationWindow.width
        height: applicationWindow.height * 0.4
        edge: Qt.BottomEdge
        bottomInset: -20
        dragMargin : -1

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            Comp.Label {
                text: qsTr("Search in translations...")
                width: parent.width
            }

            Comp.TextField {
                id: searchTextField
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Comp.Button {
                text: qsTr("OK")
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    Searching.searchNew(searchTextField.text, Quran.quranText, Quran.translation, 0, 20)
                    searchMenu.close()
                }
            }
        }
    }*/

    ListView {
        id: listView
//        snapMode: ListView.SnapOneItem
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

            Comp.Label {
                id: numberLabel
                horizontalAlignment: Text.AlignLeft
//                color: Quran.fontColor
                color: "#2779F6"
                font.underline: true
                height: suraLabel.height
                width: paintedWidth
                anchors {
                    top: parent.top
                    left: parent.left
//                    right: parent.horizontalCenter
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: "("+(index+1)+")"
                LayoutMirroring.enabled: false

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Quran.openSuraAya(model.sura,model.aya)
                    }
                }
            }

            Comp.CheckBox {
                id: bookmarkCheckBox
                enabled: false
                height: 30
                width: 30
                anchors {
                    left: parent.left
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingSmall
                    verticalCenter: textLabel.verticalCenter
                }
                LayoutMirroring.enabled: false

                Component.onCompleted: {
                    checked = Bookmarking.getStatus(model.number);
                }
            }

            Comp.Label {
                id: suraLabel
                color: Quran.fontColor
                horizontalAlignment: Text.AlignLeft
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
                font { pixelSize: Quran.fontSize-8; family: Quran.fontName; }
                LayoutMirroring.enabled: true
            }

            Comp.Label {
                id: textLabel
                color: Quran.fontColor
                horizontalAlignment: Text.AlignLeft
                height: paintedHeight + constant.paddingLarge
                anchors {
                    top: suraLabel.bottom
                    left: parent.left
//                    right: parent.right
                    right: bookmarkCheckBox.left
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                }

                wrapMode: Text.WordWrap
                text: model.text + " " + Utils.reverseString(Number(model.aya).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                font { pixelSize: Quran.fontSize; family: Quran.fontName; }
                LayoutMirroring.enabled: true
            }
            Comp.Label {
                id: translationLabel
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
                visible: (Quran.useTranslation)
            }

            onClicked: {
                if(bookmarkCheckBox.checked) {
                    Bookmarking.removeBookmark(model.number)
//                    bookmarkCheckBox.checked = false
                }
                else {
                    Bookmarking.addBookmark(model.number)
//                    bookmarkCheckBox.checked = true
                }
            }

            Connections {
                target: Bookmarking
                onBookmarkAdded: {
                    if(ayaId === model.number)
                        bookmarkCheckBox.checked = true
                }
                onBookmarkRemoved: {
                    if(ayaId === model.number)
                        bookmarkCheckBox.checked = false
                }
            }
        }
    }
}
