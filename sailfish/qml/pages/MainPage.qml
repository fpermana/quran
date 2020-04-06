import QtQuick 2.0
import Sailfish.Silica 1.0
import id.fpermana.sailquran 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: mainPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: false

    /*Component.onCompleted: {
        console.log("Translation.Removed " + Translation.Removed)
        console.log("TranslationStatus.Removed " + TranslationStatus.Removed)
        console.log("Theme.fontSizeMedium " + Theme.fontSizeMedium)
        console.log("pdms.name " + pdms.name)
        console.log("almushaf.name " + almushaf.name)
        console.log("uthmanic.name " + uthmanic.name)
        console.log(Utils.convertNumber(12345));
        console.log(Utils.reverseString("12345"));
        console.log(Utils.reverseString(Number(12345).toLocaleString(Qt.locale("ar-SA"), 'd', 0)));
    }*/

    Connections {
        target: Quran
        onCountPageChanged: {
            mainView.model = pageCount
        }
        onCurrentPageChanged: {
            if(mainView.currentIndex != currentPage - 1) {
                mainView.currentIndex = currentPage - 1
            }
        }
        onGotoPage: {
            if (mainPage.status === PageStatus.Inactive)
                pageStack.pop()
            mainView.currentIndex = page-1
            mainView.currentItem.currentIndex = 0
        }
    }

    /*Connections {
        target: Searching
        onFound: {
            if(pageStack.currentPage.objectName === "SearchDialog")
                pageStack.pop(pageStack.currentPage, PageStackAction.Immediate)
            pageStack.push(Qt.resolvedUrl("SearchPage.qml"), {keyword: keyword, ayaList: ayaList});
        }
    }*/

    Rectangle {
        anchors.fill: mainView
        color: Quran.backgroundColor
        visible: Quran.useBackground
    }

    SilicaListView {
        id: mainView
        objectName: "mainView"
        anchors.fill: parent
//        model: Controller.pages
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 1
        LayoutMirroring.enabled: true
        LayoutMirroring.childrenInherit: false

        onModelChanged: {
            mainView.currentIndex = Quran.currentPage-1
        }

        onCurrentIndexChanged: {
            if(Quran.currentPage > 0 && Quran.currentPage != currentIndex+1) {
                Quran.currentPage = currentIndex+1
            }
        }

        Item {
            visible: (mainPage.status === PageStatus.Active)
            height: constant.headerHeight
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            BackgroundItem {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                    margins: constant.paddingSmall
                }
                width: Math.max(parent.height, pageNumberLabel.width)

                Label {
                    id: pageNumberLabel
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Quran.fontColor
                    wrapMode: Text.WordWrap
                    text: Number(mainView.currentIndex+1).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
//                    text: Utils.reverseString(Number(Controller.currentPage).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                    font { pixelSize: constant.fontSizeLarge; }
                }

                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("../components/GotoDialog.qml"),
                                                                     {"page": Quran.currentPage})
                    dialog.accepted.connect(function() {
//                        header.title = "My name: " + dialog.page
                        mainView.currentIndex = dialog.page-1
                    })
                }
            }

            BackgroundItem {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    margins: constant.paddingSmall
                }
                width: Math.max(parent.height, pageNumberLabel.width)

                Label {
                    id: indexLabel
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Quran.fontColor
                    wrapMode: Text.WordWrap
                    text: "\u2026"
                    font { pixelSize: constant.fontSizeLarge; }
                }

                onClicked: {
//                    var suraId = Controller.currentPage !== null ? Controller.currentPage.suraId : 1
//                    pageStack.push(Qt.resolvedUrl("IndexPage.qml"), {suraId: suraId});
                    pageStack.push(Qt.resolvedUrl("IndexPage.qml"), {currentIndex: currentAya.sura-1});
//                    console.log(mainView.currentItem.indexAt(0, mainView.currentItem.contentY))
//                    console.log(currentAya)
                }
            }
        }

        delegate:
            /*Loader {
//            active: (index == Quran.currentPage-1) || (index == Quran.currentPage) || (index == Quran.currentPage+1)
            sourceComponent: */
            SilicaListView {
                id: pageView
                height: mainView.height - constant.headerHeight
                width: mainView.width
                focus: true
                clip: true
                interactive: model !== undefined
//                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.ApplyRange
                highlightFollowsCurrentItem: true
                visible: (index === Quran.currentPage-1) || (index === Quran.currentPage && mainPage.status === PageStatus.Active) || (index === Quran.currentPage-2 && mainPage.status === PageStatus.Active)

                onMovingVerticallyChanged: {
                    if(index === Quran.currentPage-1) {
                        Quran.currentIndex = indexAt(0, contentY)
                        Quran.lastIndex = index
                        currentAya = paging.ayaList.get(Math.max(0,Quran.currentIndex))
                    }
                }

                Component.onCompleted: {
                    if(index === Quran.lastIndex) {
//                        pageView.currentIndex = Quran.currentIndex
//                        console.log(Quran.currentIndex)
                        pageView.positionViewAtIndex(Quran.currentIndex, ListView.Beginning)
                        currentAya = paging.ayaList.get(Math.max(0,Quran.currentIndex))
                    }
                }

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
                model: paging.ayaList

                header: Item {
                    height: constant.headerHeight
                    width: pageView.width

                    Label {
                        anchors {
                            top: parent.top
                            left: parent.left
                            bottom: parent.bottom
                            margins: constant.paddingMedium
                        }
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: Quran.fontColor
                        wrapMode: Text.WordWrap
                        text: (currentAya !== null) ? currentAya.suraName : ""
                        font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
                    }
                }

                PullDownMenu {
                    id: pageMenu
                    MenuItem {
                        text: qsTr("About")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                        }
                    }
                    MenuItem {
                        text: qsTr("Setting")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("SettingPage.qml"));
                        }
                    }
                    MenuItem {
                        text: qsTr("Bookmark")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("BookmarkPage.qml"));
                        }
                    }
                    MenuItem {
                        text: qsTr("Search in translation")
                        onClicked: {
                            /*var dialog = pageStack.push(Qt.resolvedUrl("../components/SearchDialog.qml"),{})
                            dialog.accepted.connect(function() {
                                Searching.search(dialog.keyword, Quran.quranText, Quran.translation, 0, 10)
//                                dialog.close()
//                                pageStack.push(Qt.resolvedUrl("SearchPage.qml"), {keyword: dialog.keyword});
                            })*/
                            pageStack.push(Qt.resolvedUrl("SearchPage.qml"));
                        }
                    }
                }

                delegate: Item {
                    height: childrenRect.height
                    width: pageView.width
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

                        font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
                        color: Quran.fontColor
                        wrapMode: Text.WordWrap
                        height: visible ? (paintedHeight + constant.paddingMedium) : 0
                    }
                    BackgroundItem {
                        id: listItem
                        property bool menuOpen: contextMenu != null && contextMenu.parent === listItem
                        height: (menuOpen ? contextMenu.height : 0) + textLabel.height + translationLabel.height + 20
                        anchors {
                            top: bismillahLabel.bottom
                            left: parent.left
                            right: parent.right
                        }

                        Label {
                            id: textLabel
                            verticalAlignment: Text.AlignVCenter
//                            horizontalAlignment: Text.AlignRight
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
//                            color: highlighted ? constant.colorHighlighted : constant.colorLight
                            visible: (Quran.useTranslation)
                        }
                        onReleased: {
                            var text = textLabel.text
                            var length = text.length
                            var lastChar = textLabel.text.charAt(length-1)

                            if(lastChar === "\u26AA") {
                                Bookmarking.addBookmark(model.number)
//                                text = text.replace("\u26AA","\u26AB")
                            }
                            else if(lastChar === "\u26AB") {
                                Bookmarking.removeBookmark(model.number)
//                                text = text.replace("\u26AB","\u26AA")
                            }
//                            textLabel.text = text
                        }

                        Connections {
                            target: Bookmarking
                            onBookmarkAdded: {
                                if(ayaId === model.number) {
                                    var text = textLabel.text
                                    text = text.replace("\u26AA","\u26AB")
                                    textLabel.text = text
                                }
                            }
                            onBookmarkRemoved: {
                                if(ayaId === model.number) {
                                    var text = textLabel.text
                                    text = text.replace("\u26AB","\u26AA")
                                    textLabel.text = text
                                }
                            }
                        }

                        /*onPressAndHold: {
                            contextMenu.open(listItem)
                        }*/

                        ContextMenu {
                            id: contextMenu
                            /*MenuItem {
                                text: qsTr("Bookmark")
                            }*/
                        }
                    }
                }
            }
//        }
    }
}

