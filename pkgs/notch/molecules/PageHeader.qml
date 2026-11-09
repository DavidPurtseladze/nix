import QtQuick
import "../state"
import "../theme"
import "../atoms"

Item {
    id: header

    property string icon: ""
    property string title: ""
    property string note: ""
    property bool back: false
    property bool busy: false

    signal navigated

    implicitHeight: 42

    Row {
        id: leading

        anchors.left: parent.left
        anchors.leftMargin: header.back ? 10 : 16
        anchors.verticalCenter: parent.verticalCenter
        height: header.height
        spacing: 9

        BackButton {
            y: (leading.height - height) / 2
            visible: header.back

            onActivated: header.navigated()
        }

        Text {
            height: leading.height
            verticalAlignment: Text.AlignVCenter
            visible: !header.back
            text: header.icon
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 14
        }

        Text {
            height: leading.height
            verticalAlignment: Text.AlignVCenter
            text: header.title
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }
    }

    Row {
        id: tail

        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        height: header.height
        spacing: 8

        Spinner {
            height: tail.height
            verticalAlignment: Text.AlignVCenter
            visible: header.busy
        }

        Text {
            height: tail.height
            verticalAlignment: Text.AlignVCenter
            visible: text !== ""
            text: header.note
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 11
        }

        CloseButton {
            y: (tail.height - height) / 2

            onActivated: Shell.clear()
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.line
    }
}
