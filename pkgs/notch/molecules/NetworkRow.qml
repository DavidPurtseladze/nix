import QtQuick
import Quickshell.Networking
import "../theme"
import "../atoms"

Item {
    id: row

    property var network: null

    readonly property bool connected: network ? network.connected : false
    readonly property bool known: network ? network.known : false
    readonly property bool busy: network ? network.stateChanging : false
    readonly property bool secured: network
        && network.security !== WifiSecurityType.Open
        && network.security !== WifiSecurityType.Unknown

    signal asked

    implicitHeight: 40

    HoverHandler {
        id: pointer
        cursorShape: Qt.PointingHandCursor
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 9
        color: row.connected
            ? Qt.rgba(1, 1, 1, 0.07)
            : (pointer.hovered ? Theme.surface : "transparent")

        Behavior on color {
            ColorAnimation { duration: 110 }
        }
    }

    TapHandler {
        onTapped: {
            if (!row.network)
                return;
            if (row.connected) {
                row.network.disconnect();
            } else if (row.known || !row.secured) {
                row.network.connect();
            } else {
                row.asked();
            }
        }
    }

    Item {
        id: line

        width: parent.width
        height: 40

        Text {
            id: bars

            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: 18
            horizontalAlignment: Text.AlignHCenter

            readonly property int strength: row.network
                ? Math.round(row.network.signalStrength * 100)
                : 0

            text: {
                if (strength >= 75) return "󰤨";
                if (strength >= 50) return "󰤥";
                if (strength >= 25) return "󰤢";
                return "󰤟";
            }
            color: row.connected ? Theme.accent : Theme.textDim
            font.family: Theme.font
            font.pixelSize: 14
        }

        Column {
            anchors.left: bars.right
            anchors.leftMargin: 10
            anchors.right: trailing.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1

            Text {
                width: parent.width
                text: row.network ? row.network.name : ""
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 12
                font.weight: row.connected ? Font.DemiBold : Font.Normal
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                visible: text !== ""
                text: {
                    if (row.busy)
                        return "Connecting…";
                    if (row.connected)
                        return "Connected";
                    if (row.known)
                        return "Saved";
                    return "";
                }
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 10
            }
        }

        Row {
            id: trailing

            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            height: line.height
            spacing: 8

            Spinner {
                height: trailing.height
                verticalAlignment: Text.AlignVCenter
                visible: row.busy
            }

            Text {
                height: trailing.height
                verticalAlignment: Text.AlignVCenter
                visible: row.secured
                text: "󰌾"
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 11
            }

            Text {
                height: trailing.height
                verticalAlignment: Text.AlignVCenter
                visible: row.known && pointer.hovered
                text: "Forget"
                color: forget.hovered ? Theme.text : Theme.textDim
                font.family: Theme.font
                font.pixelSize: 10

                HoverHandler {
                    id: forget
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: if (row.network) row.network.forget()
                }
            }
        }
    }
}
