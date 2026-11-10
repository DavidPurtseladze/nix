import QtQuick
import QtQuick.Templates
import "../theme"
import "../atoms"

TextField {
    id: root

    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding

    leftPadding: searchIcon.width + searchIcon.anchors.leftMargin + Tokens.spacing.medium
    rightPadding: clearIcon.width + clearIcon.anchors.rightMargin + Tokens.spacing.medium
    topPadding: Tokens.padding.large
    bottomPadding: Tokens.padding.large

    color: Colours.palette.m3onSurface
    placeholderTextColor: Colours.palette.m3onSurfaceVariant
    selectionColor: Qt.alpha(Colours.palette.m3primary, 0.4)
    selectedTextColor: color

    font: Tokens.font.body.small
    renderType: TextField.NativeRendering
    cursorVisible: !readOnly
    verticalAlignment: TextInput.AlignVCenter

    cursorDelegate: Item {}

    onPressed: {
        if (!stateLayer.disabled)
            stateLayer.press(stateLayer.mouseX, stateLayer.mouseY);
    }

    background: StyledRect {
        anchors.fill: parent
        color: Colours.palette.m3surfaceContainer
        radius: Tokens.rounding.full

        StateLayer {
            id: stateLayer

            cursorShape: Qt.IBeamCursor
            disabled: root.activeFocus
            manualPressOverride: tapHandler.pressed
            onClicked: root.focus = true
        }
    }

    StyledRect {
        id: cursor

        property bool disableBlink

        x: root.cursorRectangle.x
        y: root.cursorRectangle.y
        implicitWidth: 1.5
        implicitHeight: root.cursorRectangle.height

        color: Colours.palette.m3primary
        radius: Tokens.rounding.large

        Connections {
            function onCursorPositionChanged(): void {
                if (root.activeFocus && root.cursorVisible) {
                    cursor.opacity = 1;
                    cursor.disableBlink = true;
                    enableBlink.restart();
                }
            }

            target: root
        }

        Timer {
            id: enableBlink

            interval: 500
            onTriggered: cursor.disableBlink = false
        }

        Timer {
            running: root.activeFocus && root.cursorVisible && !cursor.disableBlink
            repeat: true
            triggeredOnStart: true
            interval: 500
            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }

        Binding {
            when: !root.activeFocus || !root.cursorVisible
            cursor.opacity: 0
        }

        Behavior on x {
            Anim {
                easing.bezierCurve: [0.2, 1, 0.21, 1, 1, 1]
                duration: Tokens.anim.durations.expressiveFastEffects
            }
        }

        Behavior on opacity {
            Anim {
                type: Anim.StandardSmall
            }
        }
    }

    StyledText {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.leftPadding

        text: root.placeholderText
        color: root.placeholderTextColor
        font: root.font

        opacity: root.text ? 0 : 1

        Behavior on opacity {
            Anim {
                type: Anim.DefaultEffects
            }
        }
    }

    MaterialIcon {
        id: searchIcon

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Tokens.padding.large

        text: "search"
        color: Colours.palette.m3onSurfaceVariant
        size: Math.round(Tokens.font.icon.medium * 0.9)
    }

    Item {
        id: clearIcon

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: Tokens.padding.medium

        implicitWidth: clearLabel.implicitHeight + Tokens.padding.extraSmall
        implicitHeight: implicitWidth

        opacity: root.text ? 1 : 0

        StyledRect {
            anchors.fill: parent
            radius: Tokens.rounding.full

            StateLayer {
                disabled: !root.text
                onClicked: root.clear()
            }
        }

        MaterialIcon {
            id: clearLabel

            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            text: "clear"
            color: Colours.palette.m3onSurfaceVariant
            size: Tokens.font.icon.medium
        }

        Behavior on opacity {
            Anim {
                type: Anim.DefaultEffects
            }
        }
    }

    TapHandler {
        id: tapHandler
    }
}
