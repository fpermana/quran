import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0
import "../../js/utils.js" as Utils
import "../components" as Comp

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

    /*Rectangle {
        anchors.fill: listView
        color: Quran.backgroundColor
        visible: Quran.useBackground
    }*/

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

            Comp.Label {
                id: numberLabel
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
                LayoutMirroring.enabled: false
            }

            Comp.CheckBox {
                id: bookmarkCheckBox
                enabled: false
                height: textLabel.height
                width: 70
                anchors {
                    left: parent.left
                    leftMargin: constant.paddingMedium
                    rightMargin: constant.paddingMedium
                    verticalCenter: textLabel.verticalCenter
                }
                LayoutMirroring.enabled: false

                Component.onCompleted: {
                    checked = Bookmarking.getStatus(model.number);
                }
            }

            Comp.Label {
                id: suraLabel
                horizontalAlignment: Text.AlignLeft
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
                font { pixelSize: Quran.fontSize; family: Quran.fontName; }
                LayoutMirroring.enabled: true
            }

            Comp.Label {
                id: textLabel
                horizontalAlignment: Text.AlignLeft
                color: Quran.fontColor
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
//                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                visible: (Quran.useTranslation)
            }
            /*Rectangle {
                anchors {
                    top: translationLabel.bottom
                    left: parent.left
                    right: parent.right
                }
                height: 2
                color: "gray"
            }*/

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
