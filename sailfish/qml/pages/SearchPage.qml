import QtQuick 2.0
import Sailfish.Silica 1.0
import id.fpermana.sailquran 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: searchPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: true

    property string keyword
    property AyaList ayaList

    Connections {
        target: Searching
        onFoundMore: {
            searchPage.ayaList.addAyaList(ayas);
        }
        onFoundNew: {
            searchPage.keyword = keyword
            searchPage.ayaList = ayaList
        }
    }

    SilicaListView {
        id: searchView
        header: SearchField {
            id: searchField
            width: parent.width
            placeholderText: "Search in translation"
            text: keyword

            onTextChanged: {
                if(text.length > 3) {
                    updateTimer.restart()
                }
            }
            Timer {
                id: updateTimer
                running: false
                repeat: false
                interval: 1000
                onTriggered: {
                    Searching.searchNew(searchField.text, Quran.quranText, Quran.translation,1,10)
                }
            }
        }
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

        delegate: Item {
            id: delegateItem
            height: childrenRect.height
            width: searchView.width

            Rectangle {
                anchors.fill: parent
                color: Quran.backgroundColor
                visible: Quran.useBackground
            }

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

                    Component.onCompleted: {
                        var status = Bookmarking.getStatus(model.number);
                        text = text + (status ? " \u26AB" : " \u26AA");
                    }
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
                    textFormat: Text.RichText
//                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                    visible: (Quran.useTranslation)
                }
                onReleased: {
                    var text = textLabel.text
                    var length = text.length
                    var lastChar = textLabel.text.charAt(length-1)

                    if(lastChar === "\u26AA") {
                        Bookmarking.addBookmark(model.number)
                        text = text.replace("\u26AA","\u26AB")
                    }
                    else if(lastChar === "\u26AB") {
                        Bookmarking.removeBookmark(model.number)
                        text = text.replace("\u26AB","\u26AA")
                    }
                    textLabel.text = text
                }

                /*onPressAndHold: {
                    contextMenu.open(listItem)
                }*/

                RemorseItem { id: remorse }

                ContextMenu {
                    id: contextMenu
                    /*MenuItem {
                        text: qsTr("Delete Bookmark")
                        onClicked: {
//                            Controller.removeBookmark(model.id)
                            remorse.execute(listItem, "Deleting", function() { Controller.removeBookmark(model.id) } )
//                            Remorse.itemAction(delegateItem, "Deleting", function() { Controller.removeBookmark(model.id) })
                        }
                    }*/
                }
            }
        }
    }
}
