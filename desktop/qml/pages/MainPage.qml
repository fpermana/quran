import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0
import "../../js/utils.js" as Utils
import "../components" as Comp

Page {
    id: root

    title: qsTr("Quran")

    property Drawer menu: Drawer {
        id: drawer
        width: applicationWindow.width
        height: applicationWindow.height * 0.40
        edge: Qt.TopEdge
        topInset: -20
        dragMargin : -1

        Grid {
            columns: applicationWindow.orientation === Qt.LandscapeOrientation ? 2 : 1
            columnSpacing: 30
            rowSpacing: 30
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 50
            }
            Comp.Button {
                text: qsTr("Bookmark")

                onClicked: {
                    stackView.push("qrc:/qml/pages/BookmarkPage.qml")
                    drawer.close()
                }
            }
            Comp.Button {
                text: qsTr("Translation")

                onClicked: {
                    stackView.push("qrc:/qml/pages/TranslationPage.qml")
                    drawer.close()
                }
            }
            Comp.Button {
                text: qsTr("Setting")

                onClicked: {
                    stackView.push("qrc:/qml/pages/SettingPage.qml")
                    drawer.close()
                }
            }
            Comp.Button {
                text: qsTr("About")

                onClicked: {
                    stackView.push("qrc:/qml/pages/AboutPage.qml")
                    drawer.close()
                }
            }
        }
    }

    Drawer {
        id: gotoMenu

        property alias value: spinBox.value

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
                text: qsTr("Go to page")
                width: parent.width
            }

            Comp.SpinBox {
                id: spinBox
                from: 1
                to: Quran.pageCount
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Comp.Button {
                text: qsTr("OK")
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    swipeView.setCurrentIndex(spinBox.value-1)
                    gotoMenu.close()
                }
            }
        }
    }

    Drawer {
        id: searchMenu
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
                    Searching.search(searchTextField.text, Quran.quranText, Quran.translation, 0, 10)
                    searchMenu.close()
                }
            }
        }
    }

    footer: Item {
        height: constant.footerHeight

        anchors {
            left: parent.left
            right: parent.right
        }

        ToolButton {
            height: 40
            width: 40
            text: Number(swipeView.currentIndex+1).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            onClicked: {
                gotoMenu.open()
                gotoMenu.value = Quran.currentPage
            }
        }

        ToolButton {
            id: searchIcon
            height: 40
            width: 40
            icon.source: "qrc:/icons/search_icon.svg"
            anchors {
                right: pageIcon.left
                leftMargin: 5
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            onClicked: {
                searchMenu.open()
            }
        }

        ToolButton {
            id: pageIcon
            height: 40
            width: 40
            text: "\u2026"
            anchors {
                right: parent.right
                leftMargin: 5
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }

            onClicked: {
                stackView.push("qrc:/qml/pages/IndexPage.qml", {currentIndex: swipeView.currentItem.item.currentItem.sura-1 })
            }
        }
    }
    header: Item {
        id: headerItem

        height: constant.headerHeight

        Label {
            id: suraLabel
            verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
            color: Quran.fontColor
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: constant.paddingMedium
                rightMargin: constant.paddingMedium
                bottom: parent.bottom
            }

            wrapMode: Text.WordWrap
            text: swipeView.currentItem !== null && swipeView.currentItem.item !== null  && swipeView.currentItem.item.currentItem !== null ? swipeView.currentItem.item.currentItem.suraName : ""
            font { pixelSize: Quran.fontSize-8; family: Quran.fontName; }
            LayoutMirroring.enabled: true
        }
    }

    Connections {
        target: Quran
        onCountPageChanged: {
            pages.model = pageCount
        }
        /*onCurrentPageChanged: {
            if(swipeView.currentIndex != currentPage - 1) {
//                    swipeView.currentIndex = currentPage - 1
                swipeView.setCurrentIndex(currentPage - 1)
            }
        }*/
        onGotoPage: {
            if(stackView.currentItem !== root)
                stackView.pop()
            swipeView.setCurrentIndex(page-1)
        }
    }

    Connections {
        target: Searching
        onFound: {
            stackView.push("qrc:/qml/pages/SearchPage.qml",{keyword: keyword, ayaList: ayaList})
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        onCurrentIndexChanged: {
            if(Quran.currentPage > 0 && Quran.currentPage != currentIndex+1) {
                Quran.currentPage = currentIndex+1
            }
        }

        onCurrentItemChanged: {
            if(currentItem.item !== null && suraLabel.text && currentItem.item.itemAtIndex(0) !== null)
                suraLabel.text = currentItem.item.itemAtIndex(0).suraName
        }

        LayoutMirroring.enabled: true
        LayoutMirroring.childrenInherit: true
        orientation: Qt.Horizontal

        Repeater {
            id: pages
    //        model: 6
            onModelChanged: {
                swipeView.setCurrentIndex(Quran.currentPage-1)
            }

            Loader {
                active: (SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem)
                onActiveChanged: {
                    if(active && SwipeView.isCurrentItem) {
                        var idx = item.indexAt(0,item.contentY)
                        suraLabel.text = item.itemAtIndex(idx).suraName
                    }
                }

                sourceComponent: ListView {
                    id: listView
                    onMovingVerticallyChanged: {
                        if(index === Quran.currentPage-1) {
                            Quran.currentIndex = listView.indexAt(0,contentY)
                            Quran.lastIndex = index
                            if(listView.itemAtIndex(Quran.currentIndex) !== null)
                                suraLabel.text = listView.itemAtIndex(Quran.currentIndex).suraName
                        }
                    }
                    Component.onCompleted: {
                        if(index === Quran.lastIndex) {
                            listView.positionViewAtIndex(Quran.currentIndex, ListView.Beginning)
                        }
                    }

                    snapMode: ListView.SnapOneItem
                    spacing: 5
                    Paging {
                        id: paging
                        page: (index+1)
                        quranText: Quran.quranText
                        translation: Quran.translation
                    }
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
                            visible: (model.aya === 1 && model.sura !== 1 && model.sura !== 9)
                            text: (Quran.bismillah !== null ? Quran.bismillah.text : "")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                margins: constant.paddingMedium
                            }
                            font { family: Quran.largeFontName; pixelSize: Quran.fontSize+8; }
                            color: Quran.fontColor
                            wrapMode: Text.WordWrap
                            height: visible ? (paintedHeight + constant.paddingMedium) : 0
                        }
                        ItemDelegate {
                            height: textLabel.height + translationLabel.height + 20
                            anchors {
                                top: bismillahLabel.bottom
                                left: parent.left
                                right: parent.right
                            }
                            /*background: Rectangle {
                                color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
                            }*/
                            Comp.Label {
                                id: textLabel
                                horizontalAlignment: Text.AlignLeft
                                color: Quran.fontColor
                                height: paintedHeight + constant.paddingLarge
                                anchors {
                                    top: parent.top
                                    left: parent.left
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
                                font.pixelSize: Quran.translationFontSize
                                visible: (Quran.useTranslation)
                            }
                            Comp.CheckBox {
                                id: bookmarkCheckBox
                                enabled: false
                                anchors {
                                    right: parent.right //hiding
                                    verticalCenter: textLabel.verticalCenter
                                    rightMargin: constant.paddingMedium
                                }

                                Component.onCompleted: {
                                    checked = Bookmarking.getStatus(model.number);
                                }
                            }

                            onClicked: {
                                if(bookmarkCheckBox.checked) {
                                    Bookmarking.removeBookmark(model.number)
                                    bookmarkCheckBox.checked = false
                                }
                                else {
                                    Bookmarking.addBookmark(model.number)
                                    bookmarkCheckBox.checked = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
