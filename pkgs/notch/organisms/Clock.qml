import QtQuick
import "../theme"

// Default state, Just a simple block 
Item {
    id: clock

    property string name: "default"
    property int radius: 14

    implicitWidth: 104
    implicitHeight: 28

    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.now = new Date()
    }

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.now, "HH:mm")
        color: Theme.text
        font.family: Theme.fontMono
        font.pixelSize: 13
        font.weight: Font.Bold
    }
}
