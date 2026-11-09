import QtQuick
import "../theme"
import "../atoms"

Item {
    id: row

    property string icon: ""
    property real value: 0
    property bool muted: false
    property string readout: ""
    property int readoutWidth: 24

    readonly property alias held: bar.held

    signal moved(real value)

    implicitHeight: 24

    Text {
        id: glyph

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 18
        horizontalAlignment: Text.AlignHCenter
        text: row.icon
        color: Theme.textDim
        font.family: Theme.font
        font.pixelSize: 14
    }

    Slider {
        id: bar

        anchors.left: glyph.right
        anchors.leftMargin: 10
        anchors.right: readout.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        value: row.value
        muted: row.muted

        onMoved: v => row.moved(v)
    }

    Text {
        id: readout

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: row.readoutWidth
        horizontalAlignment: Text.AlignRight
        text: row.readout !== "" ? row.readout : Math.round(row.value * 100)
        color: Theme.text
        font.family: Theme.fontMono
        font.pixelSize: 11
    }
}
