import QtQuick 2.1
import Sailfish.Silica 1.0

QtObject {
    id: constant

    // color
    property color colorHighlighted: Theme.highlightColor
    property color colorLight: Theme.primaryColor
    property color colorMid: Theme.secondaryColor
    property color colorTextSelection: Theme.secondaryHighlightColor
    property color colorDisabled: Theme.secondaryColor

    // padding size
    property int paddingSmall: Theme.paddingSmall
    property int paddingMedium: Theme.paddingMedium
    property int paddingLarge: Theme.paddingLarge
    property int paddingXLarge: Theme.paddingLarge

    // font size
    property int fontSizeXSmall: Theme.fontSizeTiny
    property int fontSizeSmall: Theme.fontSizeExtraSmall
    property int fontSizeMedium: Theme.fontSizeSmall
    property int fontSizeLarge: Theme.fontSizeMedium
    property int fontSizeXLarge: Theme.fontSizeLarge
    property int fontSizeXXLarge: Theme.fontSizeExtraLarge
    property int fontSizeHuge: Theme.fontSizeHuge

    // graphic size
    property int graphicSizeTiny: 24
    property int graphicSizeXSmall: 28
    property int graphicSizeSmall: 32
    property int graphicSizeMedium: 48
    property int graphicSizeLarge: 72

    property int thumbnailSize: 120

    property int bannerHeight: 250

    // other
   // property int headerHeight: inPortrait ? 65 : 55
    property int headerHeight: 85

    property int charReservedPerMedia: 23

    property string fontName: newmet.name

}
