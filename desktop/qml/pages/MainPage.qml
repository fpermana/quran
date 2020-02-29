import QtQuick 2.12
import QtQuick.Controls 2.5
import id.fpermana.sailquran 1.0
import "../../js/utils.js" as Utils

Page {
    id: root

    title: "SailQuran"

    property Drawer menu: Drawer {
        id: drawer
        width: applicationWindow.width
        height: applicationWindow.height * 0.40
        edge: Qt.TopEdge
        topInset: -20

        background: Rectangle {
            radius: 20
        }

        Grid {
            columns: applicationWindow.orientation === Qt.LandscapeOrientation ? 2 : 1
            columnSpacing: 30
            rowSpacing: 30
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 50
            }
            Button {
                text: qsTr("Bookmark")
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                width: 350

                onClicked: {
                    stackView.push("qrc:/qml/pages/BookmarkPage.qml")
                    drawer.close()
                }
            }
            Button {
                text: qsTr("Translation")
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                width: 350

                onClicked: {
                    stackView.push("qrc:/qml/pages/TranslationPage.qml")
                    drawer.close()
                }
            }
            Button {
                text: qsTr("Setting")
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                width: 350

                onClicked: {
                    stackView.push("qrc:/qml/pages/SettingPage.qml")
                    drawer.close()
                }
            }
            Button {
                text: qsTr("About")
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                width: 350

                onClicked: {
                    stackView.push("qrc:/qml/pages/AboutPage.qml")
                    drawer.close()
                }
            }
            /*Button {
                text: "satu"
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
            }*/
        }

        /*Column {
            anchors.fill: parent

            ItemDelegate {
                width: parent.width
//                height: childrenRect.height
                background: Rectangle {
                    color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
                }

                Label {
                    verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                    color: constant.colorDark
                    height: paintedHeight + constant.paddingLarge
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }
                    wrapMode: Text.WordWrap
                    text: qsTr("Translation")
                    font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                }

                Component.onCompleted: {
                    height = childrenRect.height
                }

                onClicked: {
                    stackView.push("qrc:/qml/pages/TranslationPage.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                width: parent.width
//                height: childrenRect.height
                background: Rectangle {
                    color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
                }

                Label {
                    verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                    color: constant.colorDark
                    height: paintedHeight + constant.paddingLarge
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: qsTr("Setting")
                    font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                }

                Component.onCompleted: {
                    height = childrenRect.height
                }

                onClicked: {
                    stackView.push("qrc:/qml/pages/SettingPage.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                width: parent.width
//                height: childrenRect.height
                background: Rectangle {
                    color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
                }

                Label {
                    verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                    color: constant.colorDark
                    height: paintedHeight + constant.paddingLarge
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    wrapMode: Text.WordWrap
                    text: "About"
                    font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                }

                Component.onCompleted: {
                    height = childrenRect.height
                }

                onClicked: {
                    stackView.push("qrc:/qml/pages/AboutPage.qml")
                    drawer.close()
                }
            }
        }*/
    }

    Drawer {
        id: gotoMenu

        property alias value: spinBox.value

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
                text: qsTr("Go to page")
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            SpinBox {
                id: spinBox
//                value: Quran.currentPage
                from: 1
                to: Quran.pageCount
                editable: true
                anchors.horizontalCenter: parent.horizontalCenter
                width: 300
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
            }

            Button {
                text: "OK"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 300
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }

                onClicked: {
                    swipeView.setCurrentIndex(spinBox.value-1)
                    gotoMenu.close()
                }
            }
        }
    }

    Drawer {
        id: bookmarkMenu

        property alias text: bookmarkQuranLabel.text
        property alias translation: bookmarkTranslationLabel.text

        width: applicationWindow.width
        height: bookmarkColumn.height
        edge: Qt.BottomEdge
        bottomInset: -20

        background: Rectangle {
            radius: 20
        }

        Column {
            id: bookmarkColumn
            height: childrenRect.height + 25
            anchors {
                margins: 10
                left: parent.left
                right: parent.right
            }
            spacing: 20

            Label {
                id: bookmarkQuranLabel
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
//                text: model.text + " " + Utils.reverseString(Number(model.aya).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                font { pixelSize: Quran.fontSize; family: constant.fontName; }
                LayoutMirroring.enabled: true
            }
            Label {
                id: bookmarkTranslationLabel
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
//                text: model.translation
                font.pixelSize: Quran.translationFontSize
//                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                visible: (Quran.useTranslation)
            }
            Button {
                text: qsTr("Bookmark")
                anchors.horizontalCenter: parent.horizontalCenter
                width: 300
                font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
                onClicked: {
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

        /*Label {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: Quran.fontColor
            anchors.centerIn: parent

            wrapMode: Text.WordWrap
            text: Number(swipeView.currentIndex+1).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
            font.pixelSize: Quran.translationFontSize
        }*/

        ToolButton {
            height: 40
            width: 40
            text: Number(swipeView.currentIndex+1).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
            anchors {
                horizontalCenter: parent.horizontalCenter
                margins: 5
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
                margins: 5
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
                margins: 5
                verticalCenter: parent.verticalCenter
            }

            onClicked: {
                stackView.push("qrc:/qml/pages/IndexPage.qml", {currentIndex: swipeView.currentItem.item.currentItem.sura-1 })
            }
        }
    }
    header: Item {
        id: headerItem
        property alias title: suraLabel.text

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
            text: swipeView.currentItem !== null && swipeView.currentItem.item !== null ? swipeView.currentItem.item.currentItem.suraName : ""
            font { pixelSize: constant.fontSizeXLarge; family: constant.fontName; }
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
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem

                sourceComponent: ListView {
                    id: listView
                    onMovingVerticallyChanged: {
                        if(index === Quran.currentPage-1) {
                            Quran.currentIndex = listView.indexAt(0,contentY)
                            Quran.lastIndex = index
                            root.header.title = listView.itemAtIndex(Quran.currentIndex).suraName
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
                            font { family: constant.largeFontName; pixelSize: constant.fontSizeHuge; }
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
                            background: Rectangle {
                                color: parent.pressed ? constant.colorHighlightedBackground : "transparent"
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
                                    right: bookmarkLabel.left
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
//                                    right: bookmarkLabel.left
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
                            Label {
                                id: bookmarkLabel
                                //text: model.marked ? "\u26AB" : "\u26AA"
                                font { pixelSize: constant.fontSizeXLarge; family: constant.fontName; }
                                width: 60
                                height: textLabel.height
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors {
                                    right: parent.right //hiding
                                    verticalCenter: textLabel.verticalCenter
                                }

                                Component.onCompleted: {
                                    var status = Bookmarking.getStatus(model.number);
                                    text = status ? "\u25C9" : "\u25CB";
                                }
                            }

                            onClicked: {
                                if(bookmarkLabel.text == "\u25CB") {
                                    Bookmarking.addBookmark(model.number)
                                    bookmarkLabel.text = "\u25C9"
                                }
                                else {
                                    Bookmarking.removeBookmark(model.number)
                                    bookmarkLabel.text = "\u25CB"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
