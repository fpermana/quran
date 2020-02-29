import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

ApplicationWindow {
    id: applicationWindow
    visible: true
    minimumWidth: 960
    minimumHeight: 640
    title: qsTr("SailQuran")

    property int orientation: width > height ? Qt.LandscapeOrientation : Qt.PortraitOrientation

    FontLoader { id: pdms; source: "qrc:/fonts/PDMS_Saleem_QuranFont-signed.ttf" }
    FontLoader { id: almushaf; source: "qrc:/fonts/Al_Mushaf.ttf" }
    FontLoader { id: newmet; source: "qrc:/fonts/me_quran_volt_newmet.ttf" }
    FontLoader { id: uthmanic; source: "qrc:/fonts/UthmanicHafs1 Ver09.otf" }
    FontLoader { id: scheherazade; source: "qrc:/fonts/ScheherazadeRegOT.ttf" }

    QtObject {
        id: constant

        // color
        property color colorHighlighted: "#01bcf9"
        property color colorLight: "#ffffff"
        property color colorDark: "#000000"
        property color colorMid: "#b0ffffff"
        property color colorTextSelection: "#b001bcf9"
        property color colorDisabled: "#b0ffffff"
        property color colorHighlightBackground: "#00ade6"
        property color colorHighlightedBackground: "#4c00ade6"
        property color colorHighlightBackgroundOpacity: "#000000"

        // padding size
        property int paddingSmall: 8
        property int paddingMedium: 16
        property int paddingLarge: 32
        property int paddingXLarge: 32

        // font size
        property int fontSizeXSmall: 16
        property int fontSizeSmall: 20
        property int fontSizeMedium: 24
        property int fontSizeLarge: 30
        property int fontSizeXLarge: 36
        property int fontSizeXXLarge: 40
        property int fontSizeHuge: 50

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

       /*// other
       // property int headerHeight: inPortrait ? 65 : 55
        property int headerHeight: 85

        property int charReservedPerMedia: 23*/

        property string fontName: uthmanic.name
        property string largeFontName: almushaf.name
    }

    header: ToolBar {
        contentHeight: constant.headerHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u268F"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
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
            font { pixelSize: constant.fontSizeMedium; family: constant.fontName; }
        }
    }

    StackView {
        id: stackView
        initialItem: "qrc:/qml/pages/MainPage.qml"
        anchors.fill: parent
    }
}
