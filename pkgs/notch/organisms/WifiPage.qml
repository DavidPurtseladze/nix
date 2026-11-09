import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"

Item {
    id: page

    property string name: "settings.wifi"
    property int radius: 24
    property bool focusable: true

    readonly property int maxBodyHeight: 300

    readonly property var joining: Shell.joinTarget

    implicitWidth: Theme.panelWidth
    implicitHeight: header.height
        + (joining
            ? sheetLoader.height
            : Math.min(Math.max(column.height, 40), maxBodyHeight))
        + 12

    PageHeader {
        id: header

        width: parent.width
        back: true
        title: page.joining ? "Join network" : "Wi-Fi"
        note: page.joining ? "" : Network.visible.length + " in range"
        busy: Network.busy && !page.joining

        onNavigated: {
            if (page.joining)
                Shell.joinTarget = null;
            else
                Shell.settingsPage = "";
        }
    }

    Loader {
        id: sheetLoader

        anchors.top: header.bottom
        width: parent.width
        active: page.joining !== null
        visible: active

        sourceComponent: JoinSheet {
            width: sheetLoader.width
            network: Shell.joinTarget
        }
    }

    Flickable {
        id: body

        visible: page.joining === null

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
                visible: Network.visible.length === 0
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: Network.enabled ? "Looking…" : "Wi-Fi is off"
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 11
            }

            Repeater {
                model: Network.visible

                NetworkRow {
                    required property var modelData

                    width: column.width
                    network: modelData

                    onAsked: Shell.joinTarget = modelData
                }
            }
        }
    }
}
