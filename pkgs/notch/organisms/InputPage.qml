import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"

Item {
    id: page

    property string name: "settings.input"
    property int radius: 24
    property bool focusable: true

    readonly property int maxBodyHeight: 320

    implicitWidth: Theme.panelWidth
    implicitHeight: header.height
        + Math.min(Math.max(column.height, 40), maxBodyHeight)
        + 12

    onVisibleChanged: Sound.watching = visible

    PageHeader {
        id: header

        width: parent.width
        back: true
        title: "Input"
        note: Sound.sources.length + " device" + (Sound.sources.length === 1 ? "" : "s")

        onNavigated: Shell.settingsPage = ""
    }

    Flickable {
        id: body

        anchors.top: header.bottom
        anchors.topMargin: 6
        width: parent.width
        height: Math.min(Math.max(column.height, 40), page.maxBodyHeight)
        contentHeight: column.height
        clip: true
        interactive: contentHeight > height
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: column

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            width: body.width - 16

            Item {
                width: parent.width
                height: 34

                SliderRow {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 14
                    anchors.verticalCenter: parent.verticalCenter

                    icon: Sound.inputMuted ? "󰍭" : "󰍬"
                    value: Sound.inputVolume
                    muted: Sound.inputMuted

                    onMoved: v => Sound.setInputVolume(v)
                }
            }

            Repeater {
                model: Sound.sources

                AudioRow {
                    required property var modelData

                    width: column.width
                    node: modelData
                    icon: Sound.glyph(modelData, false)
                    title: Sound.title(modelData)
                    active: Sound.source === modelData

                    onPicked: Sound.setSource(modelData)
                }
            }

            Text {
                width: parent.width
                height: 34
                visible: Sound.sources.length === 0
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "No inputs"
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 11
            }

            Item {
                width: parent.width
                height: 30
                visible: Sound.deadSources.length > 0

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: Sound.deadSources.length + " input"
                        + (Sound.deadSources.length === 1 ? "" : "s")
                        + " hidden — nothing plugged in"
                    color: Theme.track
                    font.family: Theme.font
                    font.pixelSize: 10
                    elide: Text.ElideRight
                }
            }
        }
    }
}
