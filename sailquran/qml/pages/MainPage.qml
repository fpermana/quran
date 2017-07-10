import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    backNavigation: false

    /*Component.onCompleted: {
        console.log("Theme.fontSizeMedium " + Theme.fontSizeMedium)
        console.log("lateef.name " + lateef.name)
        console.log("pdms.name " + pdms.name)
        console.log("scheherazadeRegular.name " + scheherazadeRegular.name)
    }*/

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

        delegate: SilicaListView {
            id: pageView
            property int delegatePage: (index+1)
            height: mainView.height
            width: mainView.width
            focus: true

            header: Item {
                height: constant.headerHeight
                width: pageView.width/2
                Label {
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                        margins: constant.paddingMedium
                    }
                    verticalAlignment: Text.AlignVCenter
                    color: constant.colorLight
                    wrapMode: Text.WordWrap
                    text: (model !== undefined) ? model.suraName : ""
                    font { family: constant.fontName; pixelSize: constant.fontSizeXLarge; }
                }
            }

            model: {
                    if(delegatePage == Controller.currentPage-1)
                        Controller.firstPage
                    else if(delegatePage == Controller.currentPage)
                        Controller.midPage
                    else if(delegatePage == Controller.currentPage+1)
                        Controller.lastPage
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
                        leftMargin: constant.paddingMedium
                        rightMargin: constant.paddingMedium
                    }

                    font { family: constant.fontName; pixelSize: constant.fontSizeLarge; }
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
                        horizontalAlignment: Text.AlignRight
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
                        text: model.text
                        font { pixelSize: constant.fontSizeLarge; }
                        font.family: constant.fontName
                        /*font.family: {
                            if(index % 6 == 0)
                                haramain.name
                            else if(index % 6 == 1)
                                besmellah2.name
                            else if(index % 6 == 2)
                                besmellah3.name
                            else if(index % 6 == 3)
                                newmet.name
                            else if(index % 6 == 4)
                                mohammd1.name
                            else if(index % 6 == 5)
                                quraan.name
                        }*/

    //                  color: highlighted ? constant.colorHighlighted : constant.colorLight

//                        lineHeight: 1.5
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
                        font.pixelSize: constant.fontSizeMedium
    //                  color: highlighted ? constant.colorHighlighted : constant.colorLight
                    }

                    onPressAndHold: {
                        contextMenu.show(listItem)
                    }

                    ContextMenu {
                        id: contextMenu
                        MenuItem {
                            text: "Bookmark"
                            onClicked: {
                            }
                        }
                    }
                }
            }

            PullDownMenu {
                visible: delegatePage == Controller.currentPage
                MenuItem {
                    text: qsTr("Settings")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
                    }
                }
            }
        }
    }
}
