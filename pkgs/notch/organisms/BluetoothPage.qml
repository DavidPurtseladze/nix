import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"

Item {
    id: page

    property string name: "settings.bluetooth"
    property int radius: 24
    property bool focusable: true

    readonly property int maxBodyHeight: 300

    implicitWidth: Theme.panelWidth
    implicitHeight: header.height
        + Math.min(Math.max(column.height, 40), maxBodyHeight)
        + 12

    PageHeader {
        id: header

        width: parent.width
        back: true

        onNavigated: Shell.settingsPage = ""
        title: "Bluetooth"
        note: Bluetooth.nearby.length + " nearby"
        busy: Bluetooth.discovering
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

            Text {
                width: parent.width
                height: 40
                visible: Bluetooth.known.length === 0 && Bluetooth.nearby.length === 0
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: Bluetooth.enabled ? "Looking…" : "Bluetooth is off"
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 11
            }

            SectionLabel {
                width: parent.width
                visible: Bluetooth.known.length > 0
                text: "My devices"
            }

            Repeater {
                model: Bluetooth.known

                DeviceRow {
                    required property var modelData

                    width: column.width
                    device: modelData
                }
            }

            SectionLabel {
                width: parent.width
                visible: Bluetooth.nearby.length > 0
                text: "Other devices"
            }

            Repeater {
                model: Bluetooth.shown

                DeviceRow {
                    required property var modelData

                    width: column.width
                    device: modelData
                }
            }

            Item {
                width: parent.width
                height: 32
                visible: Bluetooth.hidden > 0 || Bluetooth.showAll

                HoverHandler {
                    id: more
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: Bluetooth.showAll = !Bluetooth.showAll
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.verticalCenter: parent.verticalCenter
                    text: Bluetooth.showAll
                        ? "Show less"
                        : "Show " + Bluetooth.hidden + " more"
                    color: more.hovered ? Theme.text : Theme.textDim
                    font.family: Theme.font
                    font.pixelSize: 11

                    Behavior on color {
                        ColorAnimation { duration: 110 }
                    }
                }
            }
        }
    }
}
