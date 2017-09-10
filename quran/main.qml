import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QuranQuick 1.0

ApplicationWindow {
    visible: true
    minimumHeight: 768
    minimumWidth: 1024
    title: qsTr("Hello World")

    QtObject {
        id: constant

        property int headerHeight: 80
        property int paddingMedium: 10
        property int paddingSmall: 5
    }

    FontLoader { id: pdms; source: "qrc:/fonts/PDMS_Saleem_QuranFont-signed.ttf" }
    FontLoader { id: almushaf; source: "qrc:/fonts/Al_Mushaf.ttf" }
    FontLoader { id: newmet; source: "qrc:/fonts/me_quran_volt_newmet.ttf" }
    FontLoader { id: uthmanic; source: "qrc:/fonts/UthmanicHafs1 Ver09.otf" }

    /*SwipeView {
        id: swipeView
        anchors.fill: parent
//        currentIndex: tabBar.currentIndex
        onCurrentIndexChanged: console.log("changed")

        Page1 {
        }

        Page {
            Label {
                text: qsTr("Second page")
                anchors.centerIn: parent
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }*/

    ListView {
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
//            visible: (mainPage.status == PageStatus.Active)
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

            Item {
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
//                    font { pixelSize: constant.fontSizeLarge; }
                }

                /*onClicked: {
                    var suraId = Controller.currentPage !== null ? Controller.currentPage.suraId : 1
                    pageStack.push(Qt.resolvedUrl("IndexPage.qml"), {suraId: suraId});
                }*/
            }
        }

        delegate: ListView {
            id: pageView
            property bool loaded: false
            property int delegatePage: (index+1)
            height: mainView.height - constant.headerHeight
            width: mainView.width
            focus: true
            clip: true
//            visible: ((pageView.delegatePage <= mainView.currentIndex) && mainPage.status != PageStatus.Active) ? false : true
//            visible: ((pageView.delegatePage !== Settings.currentPage) && mainPage.status != PageStatus.Active) ? false : true
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
//                    font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
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

//                    font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
                    color: Settings.fontColor
                    wrapMode: Text.WordWrap
                    height: visible ? (paintedHeight + constant.paddingMedium) : 0
                }
                Item {
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
                        text: model.text //+ " " + Utils.reverseString(Number(model.aya).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
//                        font { pixelSize: Settings.fontSize; family: constant.fontName; }
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

                    MouseArea {
                        id: contextMenu
                        /*MenuItem {
                            text: "Bookmark"
                            onClicked: {
                                Controller.addBookmark(model.id)
                            }
                        }*/
                    }
                }
            }
        }
    }
}
