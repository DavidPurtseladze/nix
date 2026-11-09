import QtQuick
import QtQuick.Window
import "../state"
import "../theme"
import "../service"
import "../molecules"

Item {
    id: settings

    property string name: "settings"
    property int radius: 24

    property bool focusable: true

    implicitWidth: Theme.panelWidth

    readonly property int maxBodyHeight: Math.max(220,
        Math.floor((Screen.height - 120) / Theme.scale)
            - tabs.height - footer.height)

    implicitHeight: footer.y + footer.height + 9

    readonly property Item page: {
        if (Shell.settingsTab === "audio")
            return audioTab;
        if (Shell.settingsTab === "alerts")
            return alertsTab;
        return controlTab;
    }

    onVisibleChanged: if (visible) {
        Backlight.refresh();
        Caffeine.refresh();
        Sunset.refresh();
    }

    TabBar {
        id: tabs

        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.panelPad
        anchors.rightMargin: Theme.panelPad

        current: Shell.settingsTab

        tabs: [
            { text: "Control",       icon: "󰕮", value: "control" },
            { text: "Audio",         icon: "󰓃", value: "audio" },
            { text: "Notifications", icon: "󰂚", value: "alerts" }
        ]

        onPicked: v => Shell.settingsTab = v
    }

    Flickable {
        id: scroll

        anchors.top: tabs.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right

        height: Math.min(settings.page.implicitHeight, settings.maxBodyHeight)
        contentHeight: settings.page.implicitHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height
        boundsBehavior: Flickable.StopAtBounds

        onHeightChanged: contentY = 0

        ControlTab {
            id: controlTab

            x: Theme.panelPad
            width: settings.width - 2 * Theme.panelPad
            visible: settings.page === this
        }

        AudioTab {
            id: audioTab

            x: Theme.panelPad
            width: settings.width - 2 * Theme.panelPad
            visible: settings.page === this
        }

        AlertsTab {
            id: alertsTab

            x: Theme.panelPad
            width: settings.width - 2 * Theme.panelPad
            visible: settings.page === this
        }
    }

    Column {
        id: footer

        anchors.top: scroll.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.panelPad
        anchors.rightMargin: Theme.panelPad
        spacing: 7

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.line
        }

        TrayStrip {
            width: parent.width
        }
    }
}
