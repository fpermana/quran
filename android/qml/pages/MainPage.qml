import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import id.fpermana.sailquran 1.0
import "../js/utils.js" as Utils
import "../components" as Comp

Comp.Page {
    id: root

    title: qsTr("Quran")
    searchable: true

    onSearching: {
        Searching.search(keyword, Quran.quranText, Quran.translation, 0, 10)
    }

    Popup {
        id: gotoPopup
        width: root.width/2
        dim: true
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        modal: true
        onOpened: {
            gotoTextField.text = ""
        }
        parent: Overlay.overlay
//        anchors.centerIn: root

//        contentItem:
        /*Column {
            spacing: 10
            anchors {
                left: parent.left
                right: parent.right
            }

            Comp.Label {
                text: qsTr("Go to page...")
                font { pixelSize: constant.fontSizeLarge; }
            }
            Comp.SpinBox {
                from: 1
                to: Quran.pageCount
                anchors.horizontalCenter: parent.horizontalCenter
                value: Quran.currentPage
            }
        }*/
        TextField {
            id: gotoTextField
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator{bottom: 1; top: Quran.pageCount;}
            placeholderText: qsTr("Go to page... (1-" + Quran.pageCount + ")")

            anchors {
                left: parent.left
                right: parent.right
            }

            onAccepted: {
                swipeView.setCurrentIndex(gotoTextField.text-1)
                gotoPopup.close()
            }
        }
    }

    /*Drawer {
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
    }*/

    /*Drawer {
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
    }*/

    /*footer: Item {
        height: constant.footerHeight

        anchors {
            left: parent.left
            right: parent.right
        }

        ToolButton {
            height: parent.height
            width: parent.height*2
            text: Number(swipeView.currentIndex+1).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
            font { pixelSize: constant.fontSizeXXLarge; family: constant.largeFontName }
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                leftMargin: 5
                rightMargin: 5
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
            icon.source: "qrc:/icons/search_icon.png"
//            text: "\u02c5"
//            text: "\u02ec"
            anchors {
                right: pageIcon.left
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
                appStackView.push("qrc:/qml/pages/IndexPage.qml", {currentIndex: swipeView.currentItem.item.currentItem.sura-1 })
            }
        }
    }*/

    header: Item {
        id: headerItem
//        color: Material.color(Material.LightBlue)

        height: constant.headerHeight
        width: root.width

        ItemDelegate {
            height: parent.height
//            width: parent.height*2
            text: Number(swipeView.currentIndex+1).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
            font { pixelSize: constant.fontSizeXXLarge; family: constant.largeFontName }
            anchors {
                left: parent.left
                leftMargin: 5
            }
            onClicked: {
                gotoPopup.open()
//                gotoMenu.open()
//                gotoMenu.value = Quran.currentPage
            }
        }

        ItemDelegate {
            id: suraLabel
            height: parent.height
//            width: parent.height*2
            text: swipeView.currentItem !== null && swipeView.currentItem.item !== null  && swipeView.currentItem.item.currentItem !== null ? swipeView.currentItem.item.currentItem.suraName : ""
//            LayoutMirroring.enabled: true
            font { pixelSize: constant.fontSizeXXLarge; family: constant.largeFontName }
            anchors {
                right: parent.right
                rightMargin: 5
            }
            onClicked: {
                appStackView.push("qrc:/qml/pages/IndexPage.qml", {currentIndex: swipeView.currentItem.item.currentItem.sura-1 })
            }
        }

//        Label {
//            id: suraLabel
//            verticalAlignment: Text.AlignVCenter
//            color: Quran.fontColor
//            anchors {
//                top: parent.top
//                left: parent.left
//                right: parent.right
//                leftMargin: constant.paddingMedium
//                rightMargin: constant.paddingMedium
//                bottom: parent.bottom
//            }

//            wrapMode: Text.WordWrap
//            text: swipeView.currentItem !== null && swipeView.currentItem.item !== null  && swipeView.currentItem.item.currentItem !== null ? swipeView.currentItem.item.currentItem.suraName : ""
//            font { pixelSize: Quran.fontSize-8; family: Quran.fontName; }
//            LayoutMirroring.enabled: true
//        }
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
            if(appStackView.currentItem !== root)
                appStackView.pop()
            swipeView.setCurrentIndex(page-1)
        }
    }

    Connections {
        target: Searching
        onFound: {
            appStackView.push("qrc:/qml/pages/SearchPage.qml",{keyword: keyword, ayaList: ayaList})
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

//                    snapMode: ListView.SnapOneItem
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
                                    rightMargin: constant.paddingSmall
                                }

                                Component.onCompleted: {
                                    checked = Bookmarking.getStatus(model.number);
                                }
                            }

                            onClicked: {
                                if(bookmarkCheckBox.checked) {
                                    Bookmarking.removeBookmark(model.number)
//                                    bookmarkCheckBox.checked = false
                                }
                                else {
                                    Bookmarking.addBookmark(model.number)
//                                    bookmarkCheckBox.checked = true
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
            }
        }
    }
}
