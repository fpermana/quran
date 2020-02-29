// NameInputDialog.qml
import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property alias page: textField.text
    Column {
        width: parent.width

        DialogHeader {
            acceptText: "Go"
        }

        TextField {
            id: textField
            width: parent.width
            placeholderText: "1-604"
            label: "Go to page (1-604)"
            validator: IntValidator {bottom: 1; top: 604}
            inputMethodHints: Qt.ImhDigitsOnly
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
//            name = nameField.text
        }
    }
}
