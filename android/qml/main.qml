import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.12
//import QtQuick.Controls.Universal 2.12
import "components" as Comp

ApplicationWindow {
    id: applicationWindow
    visible: true
    minimumWidth: 960
    minimumHeight: 640
    title: qsTr("SailQuran")

    function changeTheme(theme) {
        Material.theme = theme
        Setting.materialTheme = theme
    }

    onClosing: {
        if(searchTextField.visible) {
            searchTextField.visible = false
            close.accepted = false
        }

        if(close.accepted && appDrawer.position === 1) {
            appDrawer.close()
            close.accepted = false
        }
        if(close.accepted && appStackView.currentItem.menu !== null) {
            if(appStackView.currentItem.menu.position === 1) {
                appStackView.currentItem.menu.close()
                close.accepted = false
            }
        }
        if(close.accepted && appStackView.depth > 1) {
            appStackView.pop()
            close.accepted = false
        }
    }

    Drawer {
        id: appDrawer
        width: applicationWindow.width * 0.6
        height: applicationWindow.height - applicationWindow.header.height
        y: applicationWindow.header.height
        dragMargin : -1

        Column {
            anchors.fill: parent
            spacing: 10

            ItemDelegate {
                text: qsTr("Bookmark")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                font { pixelSize: constant.fontSizeLarge; }

                onClicked: {
                    appStackView.push("qrc:/qml/pages/BookmarkPage.qml")
                    appDrawer.close()
                }
            }

            /*ItemDelegate {
                text: qsTr("Translation")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                font { pixelSize: constant.fontSizeLarge; }

                onClicked: {
                    appStackView.push("qrc:/qml/pages/TranslationPage.qml")
                    appDrawer.close()
                }
            }*/

            ItemDelegate {
                text: qsTr("Setting")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                font { pixelSize: constant.fontSizeLarge; }

                onClicked: {
                    appStackView.push("qrc:/qml/pages/SettingPage.qml")
                    appDrawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("About")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                font { pixelSize: constant.fontSizeLarge; }

                onClicked: {
                    appStackView.push("qrc:/qml/pages/AboutPage.qml")
                    appDrawer.close()
                }
            }
        }
    }

//    Material.theme: Material.Dark // Material.Light
//    Universal.theme: Universal.Light // Universal.Dark
//    Universal.theme: Setting.universalTheme
    Material.theme: Setting.materialTheme

    property int orientation: width > height ? Qt.LandscapeOrientation : Qt.PortraitOrientation

    FontLoader { id: pdms; source: "qrc:/fonts/PDMS_Saleem_QuranFont-signed.ttf" }
    FontLoader { id: almushaf; source: "qrc:/fonts/Al_Mushaf.ttf" }
    FontLoader { id: newmet; source: "qrc:/fonts/me_quran_volt_newmet.ttf" }
    FontLoader { id: uthmanic; source: "qrc:/fonts/UthmanicHafs1 Ver09.otf" }
    FontLoader { id: scheherazade; source: "qrc:/fonts/ScheherazadeRegOT.ttf" }

    QtObject {
        id: constant

        // padding size
        property int paddingSmall: 8
        property int paddingMedium: 16
        property int paddingLarge: 32
        property int paddingXLarge: 48

        // font size
        property int fontSizeXSmall: Setting.smallFontSize - 4
        property int fontSizeSmall: Setting.smallFontSize
        property int fontSizeMedium: Setting.fontSize
        property int fontSizeLarge: Setting.largeFontSize
        property int fontSizeXLarge: Setting.largeFontSize + 4
        property int fontSizeXXLarge: Setting.largeFontSize + 11
        property int fontSizeHuge: Setting.largeFontSize + 16

        // graphic size
        property int graphicSizeTiny: 24
        property int graphicSizeXSmall: 28
        property int graphicSizeSmall: 32
        property int graphicSizeMedium: 48
        property int graphicSizeLarge: 72

        property int thumbnailSize: 120

        property int bannerHeight: 250
        property int headerHeight: 60
        property int footerHeight: 50

        property string fontName: uthmanic.name
        property string largeFontName: almushaf.name
    }

    header: ToolBar {
        contentHeight: constant.headerHeight

        ToolButton {
            id: appMenu
            text: appStackView.depth > 1 ? "\u25C0" : "\u2261"
            font.pixelSize: constant.fontSizeXXLarge
            width: parent.height
            visible: !searchTextField.visible
            onClicked: {
                var done = false;
//                if(appStackView.currentItem.menu !== null) {
//                    console.log(appStackView.currentItem.menu)
//                    if(appStackView.currentItem.menu.opened) {
//                        appStackView.currentItem.menu.close()
//                        done = true
//                    }
//                }

                if(!done && appDrawer.position === 1) {
                    appDrawer.close()
                    done = true
                }
                if(!done && appStackView.depth > 1) {
                    appStackView.pop()
                    done = true
                }
                if(!done && appDrawer.position === 0) {
                    appDrawer.open()
                    done = true
                }
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
        }

        Comp.Label {
            id: titleLabel
            text: appStackView.currentItem != null ? appStackView.currentItem.title : ""
            anchors.centerIn: parent
            font { pixelSize: constant.fontSizeXLarge; }
            visible: !searchTextField.visible
        }

        TextField {
            id: searchTextField
            placeholderText: qsTr("Search in translation...")
            anchors {
                right: searchIcon.left
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: constant.paddingMedium
                rightMargin: constant.paddingMedium
            }
            visible: false
            onAccepted: {
                if(searchTextField.text !== "") {
                    appStackView.currentItem.search(searchTextField.text)
                    focus = false
                }
            }
        }

        ToolButton {
            id: searchIcon
            width: parent.height
            icon.source: "qrc:/icons/search_icon.png"
            anchors {
                right: pageMenu.visible ? pageMenu.left : parent.right
                verticalCenter: parent.verticalCenter
            }
            onClicked: {
                if(!searchTextField.visible) {
                    searchTextField.visible = true
                    searchTextField.forceActiveFocus()
                }
                else if(searchTextField.text !== "") {
                    appStackView.currentItem.search(searchTextField.text)
                }
            }
            visible: appStackView.currentItem !== null && appStackView.currentItem.searchable
        }

        ToolButton {
            id: pageMenu
            text: "\u22EE"
            font.pixelSize: constant.fontSizeXLarge
            visible: appStackView.currentItem.menu !== null
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            onClicked: {
//                if(appDrawer.position === 1)
//                    appDrawer.close()
//                else if(appStackView.currentItem.menu !== null) {
                    appStackView.currentItem.menu.popup(applicationWindow.width - appStackView.currentItem.menu.width,0)
//                }
            }
        }
    }

    StackView {
        id: appStackView
        initialItem: "qrc:/qml/pages/MainPage.qml"
        anchors.fill: parent
    }
}
