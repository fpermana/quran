import QtQuick 2.0
import Sailfish.Silica 1.0
import "qrc:/js/utils.js" as Utils

Page {
    id: aboutPage
    allowedOrientations: Orientation.Portrait
//    backNavigation: false

    ListModel {
        id: detailModel

        ListElement {
            title: "Contributors"
            detail: ""
        }

        ListElement {
            title: "Application License"
            detail: ""
        }

        ListElement {
            title: "License for simplified text"
            detail: ""
        }

        ListElement {
            title: "Translations license"
            detail: ""
        }
    }

    SilicaListView {
        header: Item {
            width: aboutPage.width
            height: 200
        }
    }
}
