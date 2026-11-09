import QtQuick
import "../theme"
import "../atoms"

Item {
    id: row

    property string label: ""
    property string value: ""
    property bool dim: false

    implicitHeight: 24

    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: row.label
        color: Theme.textDim
        font.family: Theme.font
        font.pixelSize: 11
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: row.value
        color: row.dim ? Theme.textDim : Theme.text
        font.family: Theme.font
        font.pixelSize: 11
        font.weight: Font.DemiBold
    }
}
