import QtQuick
import "../service"
import "../theme"
import "../atoms"

Item {
    id: root

    required property var modelData
    required property var list

    readonly property list<string> swatches: ["base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F"]

    implicitHeight: Tokens.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        radius: Tokens.rounding.large
        onClicked: Themes.apply(root.modelData.scheme)
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Tokens.padding.medium
        anchors.rightMargin: Tokens.padding.medium
        anchors.margins: Tokens.padding.small

        StyledRect {
            id: preview

            anchors.verticalCenter: parent.verticalCenter

            border.width: 1
            border.color: Qt.alpha(root.modelData?.base03 ?? "#808080", 0.5)

            color: root.modelData?.base00 ?? "transparent"
            radius: Tokens.rounding.full
            implicitWidth: parent.height * 0.8
            implicitHeight: parent.height * 0.8

            Item {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                implicitWidth: parent.implicitWidth / 2
                clip: true

                StyledRect {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    implicitWidth: preview.implicitWidth
                    color: root.modelData?.base0D ?? "transparent"
                    radius: Tokens.rounding.full
                }
            }
        }

        Column {
            anchors.left: preview.right
            anchors.leftMargin: Tokens.spacing.medium
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width - preview.width - anchors.leftMargin - (current.active ? current.width + Tokens.spacing.medium : 0)
            spacing: Tokens.spacing.extraSmall

            StyledText {
                width: parent.width
                text: root.modelData?.name ?? ""
                font: Tokens.font.body.medium
                elide: Text.ElideRight
            }

            Row {
                spacing: Tokens.spacing.extraSmall

                Repeater {
                    model: root.swatches

                    Rectangle {
                        required property string modelData

                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: root.modelData?.[modelData] ?? "transparent"
                        border.width: 1
                        border.color: Qt.alpha(Colours.palette.m3onSurface, 0.15)
                    }
                }
            }
        }

        Loader {
            id: current

            asynchronous: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            active: root.modelData?.scheme === Themes.current

            sourceComponent: MaterialIcon {
                text: "check"
                color: Colours.palette.m3onSurfaceVariant
                size: Tokens.font.icon.large
            }
        }
    }
}
