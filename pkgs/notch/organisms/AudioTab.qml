import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"

Column {
    id: tab

    spacing: 9

    SectionLabel {
        width: parent.width
        text: "Now playing"
    }

    MediaCard {
        width: parent.width
        visible: Media.available
    }

    Rectangle {
        width: parent.width
        height: 56
        radius: 14
        color: Theme.surface
        visible: !Media.available

        Text {
            anchors.centerIn: parent
            text: "Nothing playing"
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 11
        }
    }

    SectionLabel {
        width: parent.width
        text: "Devices"
    }

    SliderRow {
        width: parent.width
        icon: Sound.muted ? "󰖁" : "󰕾"
        value: Sound.volume
        muted: Sound.muted

        onMoved: v => Sound.setVolume(v)
    }

    SettingTile {
        width: parent.width
        switchable: false
        expandable: true
        icon: Sound.muted ? "󰖁" : "󰕾"
        label: "Output"
        value: Sound.label !== "" ? Sound.label : "None"
        on: !Sound.muted

        onOpened: Shell.settingsPage = "output"
    }

    SliderRow {
        width: parent.width
        visible: Sound.source !== null
        icon: Sound.inputMuted ? "󰍭" : "󰍬"
        value: Sound.inputVolume
        muted: Sound.inputMuted

        onMoved: v => Sound.setInputVolume(v)
    }

    SettingTile {
        width: parent.width
        switchable: false
        expandable: true
        icon: Sound.inputMuted ? "󰍭" : "󰍬"
        label: "Input"
        value: Sound.source ? Sound.title(Sound.source) : "None"
        on: Sound.source !== null && !Sound.inputMuted

        onOpened: Shell.settingsPage = "input"
    }
}
