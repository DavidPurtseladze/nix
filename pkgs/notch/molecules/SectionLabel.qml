import QtQuick
import "../theme"

Item {
    id: section

    property alias text: label.text

    implicitHeight: 26

    Text {
        id: label

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4

        color: Theme.textDim
        font.family: Theme.font
        font.pixelSize: 10
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 0.6
    }
}
