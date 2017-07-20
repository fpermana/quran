import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: mainPage
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: false

    Component.onCompleted: {
        console.log("Theme.fontSizeMedium " + Theme.fontSizeMedium)
        console.log("pdms.name " + pdms.name)
        console.log("almushaf.name " + almushaf.name)
        console.log(Utils.convertNumber(12345));
        console.log(Utils.reverseString("12345"));
        console.log(Utils.reverseString(Number(12345).toLocaleString(Qt.locale("ar-SA"), 'd', 0)));
    }

//    onStatusChanged: console.log(page.status)

    /*Rectangle {
        anchors.fill: mainView
        color: "blue"
    }*/

    SilicaListView {
        id: mainView
        objectName: "mainView"
        property bool loaded: false
        anchors.fill: parent
        model: Controller.pages
        layoutDirection: Qt.RightToLeft
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal
        Component.onCompleted: {
            positionViewAtIndex(Controller.currentPage-1, ListView.Beginning);
            loaded = true
        }
        visibleArea.onXPositionChanged: {
            if(loaded) {
                var p = Math.round(Controller.pages - Controller.pages * visibleArea.xPosition)
                if(p == Controller.currentPage-1 || p == Controller.currentPage+1)
                    Controller.currentPage = p
            }
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

                Label {
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: constant.colorLight
                    wrapMode: Text.WordWrap
                    text: Number(Controller.currentPage).toLocaleString(Qt.locale("ar-SA"), 'd', 0)
//                    text: Utils.reverseString(Number(Controller.currentPage).toLocaleString(Qt.locale("ar-SA"), 'd', 0))
                    font { family: constant.largeFontName; pixelSize: constant.fontSizeXXLarge; }
                }

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("IndexPage.qml"), {suraId: Controller.midPage.suraId});
                }
            }
        }

        delegate: SilicaListView {
            id: pageView
            property int delegatePage: (index+1)
            height: mainView.height - constant.headerHeight
            width: mainView.width
            focus: true
            clip: true
            visible: ((pageView.delegatePage == Controller.currentPage-1) && mainPage.status != PageStatus.Active) ? false : true
//            onVisibleChanged: console.log(delegatePage + " " + )

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
                    color: constant.colorLight
                    wrapMode: Text.WordWrap
                    text: (model !== undefined) ? model.suraName : ""
                    font { family: constant.largeFontName; pixelSize: constant.fontSizeXLarge; }
                }
            }
//            onContentYChanged: console.log("contentY " + contentY + " " + delegatePage)

//            visibleArea.onYPositionChanged: {
//                console.log(pageView.count * visibleArea.yPosition)
//            }

            model: {
                    if(delegatePage == Controller.currentPage-1)
                        Controller.firstPage
                    else if(delegatePage == Controller.currentPage)
                        Controller.midPage
                    else if(delegatePage == Controller.currentPage+1)
                        Controller.lastPage
            }
//            onModelChanged: console.log("model " + model)

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
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    font { family: constant.fontName; pixelSize: constant.fontSizeXLarge; }
                    color: constant.colorLight
                    wrapMode: Text.WordWrap
                    height: visible ? (paintedHeight + constant.paddingMedium) : 0
                }
                BackgroundItem {
                    id: listItem
                    property bool menuOpen: contextMenu != null && contextMenu.parent === listItem
                    height: (menuOpen ? contextMenu.height : 0) + textLabel.contentHeight + translationLabel.contentHeight + 40
                    anchors {
                        top: bismillahLabel.bottom
                        left: parent.left
                        right: parent.right
                    }

                    Label {
                        id: textLabel
                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
                        color: constant.colorLight
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
                        color: constant.colorLight
                        height: paintedHeight + constant.paddingLarge
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
                visible: delegatePage == Controller.currentPage
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

