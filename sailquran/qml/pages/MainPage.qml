import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: mainPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: false

    /*Component.onCompleted: {
        console.log("Theme.fontSizeMedium " + Theme.fontSizeMedium)
        console.log("pdms.name " + pdms.name)
        console.log("almushaf.name " + almushaf.name)
        console.log("uthmanic.name " + uthmanic.name)
        console.log(Utils.convertNumber(12345));
        console.log(Utils.reverseString("12345"));
        console.log(Utils.reverseString(Number(12345).toLocaleString(Qt.locale("ar-SA"), 'd', 0)));
    }*/

    Connections {
        target: Controller
        onPageChanged: {
            mainView.currentIndex = page-1
        }
    }

//    onStatusChanged: console.log(page.status)

    Rectangle {
        anchors.fill: mainView
        color: Settings.backgroundColor
        visible: Settings.useBackground
    }

    SilicaListView {
        id: mainView
        objectName: "mainView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.pages
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 1
        LayoutMirroring.enabled: true
        LayoutMirroring.childrenInherit: false
        onCurrentIndexChanged: {
            if(loaded) {
                Settings.currentPage = currentIndex+1
                Controller.changePage(currentIndex+1)
            }
        }

        Component.onCompleted: {
            currentIndex = Settings.currentPage-1
            loaded = true
        }

        Item {
            visible: (mainPage.status == PageStatus.Active)
            height: constant.headerHeight
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            /*Label {
                anchors {
                    right: parent.right
                    left: parent.left
                    bottom: parent.bottom
                    margins: constant.paddingMedium
                }
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: constant.colorLight
                wrapMode: Text.WordWrap
                text: Utils.reverseString(Number(Controller.currentPage).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                font { family: constant.fontName; pixelSize: constant.fontSizeLarge; }
            }*/

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
                    color: Settings.fontColor
                    wrapMode: Text.WordWrap
                    text: Number(Settings.currentPage).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
//                    text: Utils.reverseString(Number(Controller.currentPage).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                    font { pixelSize: constant.fontSizeLarge; }
                }

                onClicked: {
                    var suraId = Controller.currentPage !== null ? Controller.currentPage.suraId : 1
                    pageStack.push(Qt.resolvedUrl("IndexPage.qml"), {suraId: suraId});
                }
            }
        }

        delegate: SilicaListView {
            id: pageView
            property bool loaded: false
            property int delegatePage: (index+1)
            height: mainView.height - constant.headerHeight
            width: mainView.width
            focus: true
            clip: true
//            visible: ((pageView.delegatePage <= mainView.currentIndex) && mainPage.status != PageStatus.Active) ? false : true
            visible: ((pageView.delegatePage !== Settings.currentPage) && mainPage.status != PageStatus.Active) ? false : true
            interactive: model !== undefined
//            snapMode: ListView.SnapToItem
//            highlightRangeMode: ListView.StrictlyEnforceRange
//            highlightFollowsCurrentItem: false
//            currentIndex: 0
//            onCurrentIndexChanged: {
//                console.log(currentIndex)
//            }

            onMovingVerticallyChanged: {
                if(!movingVertically && !pageMenu.active && loaded)
                    Controller.setYPosition(delegatePage, contentY)
            }

            Component.onCompleted: {
                if(pageView.model === undefined) {
                    Controller.gatherPage(delegatePage)
                    pageView.model = Controller.getPage(delegatePage)
                }

                if(delegatePage == Settings.currentPage) {
                    var yPosition = Controller.getYPosition(delegatePage)
                    if(yPosition !== -1)
                        contentY = yPosition
                }

                /*var yPosition = Controller.getYPosition(delegatePage)
                if(yPosition === -1)
                    Controller.setYPosition(delegatePage, contentY)
                else
                    contentY = yPosition*/

                loaded = true
            }

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
                    color: Settings.fontColor
                    wrapMode: Text.WordWrap
                    text: (model !== undefined) ? model.suraName : ""
                    font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
                }
            }

            delegate: Item {
                height: childrenRect.height
                width: pageView.width
                Label {
                    id: bismillahLabel
                    visible: (model.aya === 1 && model.sura !== 1)
                    text: (model.aya === 1 && model.sura !== 1 ? Controller.bismillah : "")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: constant.paddingMedium
                    }

                    font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
                    color: Settings.fontColor
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
//                        horizontalAlignment: Text.AlignRight
                        color: Settings.fontColor
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
                        font { pixelSize: Settings.fontSize; family: constant.fontName; }
                        LayoutMirroring.enabled: true
                    }
                    Label {
                        id: translationLabel
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignJustify
                        color: Settings.fontColor
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
                        font.pixelSize: Settings.translationFontSize
    //                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                        visible: (Settings.useTranslation)
                    }

                    /*onPressAndHold: {
                        contextMenu.show(listItem)
                    }*/

                    ContextMenu {
                        id: contextMenu
                        MenuItem {
                            text: "Bookmark"
                            onClicked: {
                                Controller.addBookmark(model.id)
                            }
                        }
                    }
                }
            }

            PullDownMenu {
                id: pageMenu
                visible: delegatePage == Settings.currentPage
                MenuItem {
                    text: qsTr("About")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                    }
                }
                MenuItem {
                    text: qsTr("Settings")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
                    }
                }
                /*MenuItem {
                    text: qsTr("Bookmarks")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("BookmarksPage.qml"));
                    }
                }*/
            }
        }
    }
}

