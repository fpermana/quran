import QtQuick 2.0
import Sailfish.Silica 1.0
import id.fpermana.sailquran 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: bookmarkPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: true

    property AyaList ayaList

    Component.onCompleted: {
        Bookmarking.getBookmarkList(Quran.quranText, Quran.translation);
    }

    Connections {
        target: Bookmarking
        onLoaded: {
            bookmarkPage.ayaList = ayaList;
        }
        onLoadedMore: {
            bookmarkPage.ayaList.addAyaList(ayas);
        }
    }

    Rectangle {
        anchors.fill: bookmarkView
        color: Quran.backgroundColor
        visible: Quran.useBackground
    }

    SilicaListView {
        id: bookmarkView
        objectName: "bookmarkView"
//        property bool loaded: false
        anchors.fill: parent
        model: ayaList

        header: Item {
            id: header
            height: constant.headerHeight
            width: parent.width
            anchors {
                right: parent.right
                rightMargin: constant.paddingMedium
            }

            Label {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    rightMargin: constant.paddingMedium
                }
                verticalAlignment: Text.AlignVCenter
                color: Quran.fontColor
                wrapMode: Text.WordWrap
                text: qsTr("Bookmark")
            }
        }

        onAtYEndChanged: {
            if(atYEnd && ayaList !== null) {
                var lastItem = ayaList.get(count-1)
                if(lastItem !== null)
                    Bookmarking.loadMoreBookmarkList(Quran.quranText,Quran.translation,lastItem.number)
            }
        }

        delegate: Item {
            id: delegateItem
            height: childrenRect.height
            width: bookmarkView.width

            BackgroundItem {
                id: listItem
                property bool menuOpen: contextMenu != null && contextMenu.parent === listItem
                height: (menuOpen ? contextMenu.height : 0) + suraLabel.height + textLabel.height + translationLabel.height
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
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
                    font { pixelSize: constant.fontSizeSmall; family: constant.fontName; }
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
                    font.pixelSize: Quran.translationFontSize
//                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                    visible: (Quran.useTranslation)
                }

                onPressAndHold: {
                    contextMenu.show(listItem)
                }

                RemorseItem { id: remorse }

                ContextMenu {
                    id: contextMenu
                    MenuItem {
                        text: qsTr("Delete Bookmark")
                        onClicked: {
                            remorse.execute(listItem, "Deleting", function() { Controller.removeBookmark(model.id) } )
                        }
                    }
                }
            }
        }
    }
}
