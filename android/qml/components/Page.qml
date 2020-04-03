import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id: root

    function search(keyword) {
        searching(keyword)
    }

    property Menu menu
    property bool searchable: false

    signal searching(string keyword)
}
