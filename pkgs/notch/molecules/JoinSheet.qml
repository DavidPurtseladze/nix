import QtQuick
import Quickshell.Networking
import "../state"
import "../theme"
import "../atoms"

Item {
    id: sheet

    property var network: null

    readonly property bool busy: network ? network.stateChanging : false
    readonly property bool connected: network ? network.connected : false
    readonly property int strength: network
        ? Math.round(network.signalStrength * 100)
        : 0

    property bool submitted: false
    property bool failed: false
    property bool reveal: false

    implicitHeight: column.height + 28

    onNetworkChanged: {
        submitted = false;
        failed = false;
        reveal = false;
        psk.text = "";
    }

    onConnectedChanged: if (connected) Shell.joinTarget = null

    onBusyChanged: {
        if (!busy && submitted && !connected) {
            failed = true;
            submitted = false;
            psk.text = "";
            psk.forceActiveFocus();
        }
    }

    function submit() {
        if (!network || psk.text === "")
            return;
        failed = false;
        submitted = true;
        network.connectWithPsk(psk.text);
    }

    Column {
        id: column

        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        spacing: 12

        IconBadge {
            anchors.horizontalCenter: parent.horizontalCenter

            diameter: 46
            on: true
            icon: {
                if (sheet.strength >= 75) return "󰤨";
                if (sheet.strength >= 50) return "󰤥";
                if (sheet.strength >= 25) return "󰤢";
                return "󰤟";
            }
        }

        Column {
            width: parent.width
            spacing: 2

            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: sheet.network ? sheet.network.name : ""
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 14
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: {
                    if (sheet.submitted)
                        return "Connecting…";
                    if (sheet.failed)
                        return "Wrong password — try again";
                    return "This network is password protected";
                }
                color: sheet.failed ? "#e0796f" : Theme.textDim
                font.family: Theme.font
                font.pixelSize: 10
            }
        }

        Rectangle {
            width: parent.width
            height: 36
            radius: 10
            color: Theme.surface

            border.width: 1
            border.color: sheet.failed
                ? Qt.rgba(0.88, 0.47, 0.44, 0.55)
                : (psk.activeFocus ? Qt.rgba(1, 1, 1, 0.18) : "transparent")

            Behavior on border.color {
                ColorAnimation { duration: 140 }
            }

            TextInput {
                id: psk

                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 42
                verticalAlignment: TextInput.AlignVCenter

                enabled: !sheet.submitted
                echoMode: sheet.reveal ? TextInput.Normal : TextInput.Password
                passwordCharacter: "•"
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 12
                selectByMouse: true
                selectionColor: Theme.accent

                onTextChanged: sheet.failed = false
                onAccepted: sheet.submit()

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: psk.text === ""
                    text: "Password"
                    color: Theme.textDim
                    font.family: Theme.font
                    font.pixelSize: 12
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 13
                anchors.verticalCenter: parent.verticalCenter

                text: sheet.reveal ? "󰈉" : "󰈈"
                color: eye.hovered ? Theme.text : Theme.textDim
                font.family: Theme.font
                font.pixelSize: 13

                HoverHandler {
                    id: eye
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: sheet.reveal = !sheet.reveal
                }
            }
        }

        Row {
            width: parent.width
            spacing: 8

            readonly property real half: (width - spacing) / 2

            SheetButton {
                width: parent.half
                text: "Cancel"

                onActivated: Shell.joinTarget = null
            }

            SheetButton {
                width: parent.half
                primary: true
                text: sheet.submitted ? "Joining…" : "Join"
                enabled: psk.text !== "" && !sheet.submitted

                onActivated: sheet.submit()
            }
        }
    }

    Component.onCompleted: psk.forceActiveFocus()
}
