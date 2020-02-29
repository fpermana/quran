// NameInputDialog.qml
import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    objectName: "SearchDialog"
    /*acceptDestination: Qt.resolvedUrl("../pages/SearchPage.qml")
    acceptDestinationAction: PageStackAction.Replace
    acceptDestinationProperties : {keyword: searchField.text}*/

    property string keyword

    Column {
        width: parent.width

        DialogHeader {
            acceptText: "Search"
        }

        SearchField {
            id: searchField
            width: parent.width
            placeholderText: "Search in translation"
            label: "Keyword"
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            keyword = searchField.text
        }
    }
}
