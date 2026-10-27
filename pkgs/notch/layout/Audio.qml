import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../state"
import "../theme"

Item {
    id: audio

    property string name: "audio"
    property int radius: 14

    implicitWidth: 196
    implicitHeight: 28

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property int percent: Math.round(volume * 100)

    // Binding a PwNode: this is used to track audio properties live.
    PwObjectTracker {
        objects: [audio.sink]
    }

    // Make sure component is fully loaded on lunch
    // Used to avoid component showing up and then feeling in to actual sound location
    property bool ready: false

    Timer {
        interval: 1200
        running: true
        onTriggered: audio.ready = true
    }

    function show() {
        if (!ready)
            return;
        Shell.notchState = "audio";
        hide.restart();
    }

    onVolumeChanged: show()
    onMutedChanged: show()

    Timer {
        id: hide
        interval: 1400
        onTriggered: Shell.notchState = "default"
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 13
        anchors.rightMargin: 13
        spacing: 9

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: audio.muted ? "󰖁" : "󰕾"
            color: Theme.text
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 14
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 14 - 9 - 9 - 26
            height: 4
            radius: 2
            color: Qt.rgba(1, 1, 1, 0.2)

            Rectangle {
                property real level: audio.muted ? 0 : audio.volume

                Behavior on level {
                    NumberAnimation { duration: 120 }
                }

                width: parent.width * level
                height: parent.height
                radius: parent.radius
                color: Theme.text
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: 26
            horizontalAlignment: Text.AlignRight
            text: audio.percent
            color: Theme.text
            font.family: "FiraCode Nerd Font Mono"
            font.pixelSize: 13
        }
    }
}
