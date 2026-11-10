pragma ComponentBehavior: Bound

import QtQuick
import "../state"
import "../theme"
import "../atoms"
import "../molecules"

Item {
    id: root

    required property real maxHeight
    required property SearchBar search
    readonly property var currentList: appList

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    clip: true

    implicitWidth: Tokens.sizes.itemWidth
    implicitHeight: Math.min(maxHeight, appList.implicitHeight > 0 ? appList.implicitHeight : empty.implicitHeight)

    AppList {
        id: appList

        anchors.fill: parent
        search: root.search
    }

    Row {
        id: empty

        opacity: appList.count === 0 ? 1 : 0
        scale: appList.count === 0 ? 1 : 0.5

        spacing: Tokens.spacing.medium
        padding: Tokens.padding.large

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        MaterialIcon {
            text: "manage_search"
            color: Colours.palette.m3onSurfaceVariant
            size: Tokens.font.icon.extraLarge

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: "No results"
                color: Colours.palette.m3onSurfaceVariant
                font: Tokens.font.body.large
            }

            StyledText {
                text: "Try searching for something else"
                color: Colours.palette.m3onSurfaceVariant
                font: Tokens.font.body.medium
            }
        }

        Behavior on opacity {
            Anim {
                type: Anim.DefaultEffects
            }
        }

        Behavior on scale {
            Anim {}
        }
    }

    Behavior on implicitHeight {
        enabled: Shell.open

        Anim {}
    }
}
