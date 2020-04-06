import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
//import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    id: applicationWindow
    visible: true
    minimumWidth: 960
    minimumHeight: 640
    title: qsTr("SailQuran")

    function changeTheme(theme) {
        Universal.theme = theme
        Setting.universalTheme = theme
    }

    Universal.theme: Setting.universalTheme
    Universal.accent: Universal.color(Universal.Red)

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
        Universal.foreground: "#ffffff"
//        Universal.background: "#005ee2"

        contentHeight: constant.headerHeight

        background: Rectangle {
            color: "#005ee2"
        }

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u268F"
            font.pixelSize: constant.fontSizeXXLarge
            width: parent.height
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    stackView.currentItem.menu.open()
                }
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
        }

        visible: stackView.currentItem.menu !== undefined || stackView.depth > 1

        Label {
            text: stackView.currentItem != null ? stackView.currentItem.title : ""
            anchors.centerIn: parent
            font { pixelSize: constant.fontSizeXLarge; }
        }
    }

    StackView {
        id: stackView
        initialItem: "qrc:/qml/pages/MainPage.qml"
        anchors.fill: parent
    }
}
