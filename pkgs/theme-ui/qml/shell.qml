import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
  PanelWindow {
    id: win

    property int sliceW: 140
    property int expandedW: 920
    property int sliceH: 520
    property int overlap: -30
    property int skew: 35
    property var palettes: []

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    color: win.ui.base00 + "ee"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    property var ui: ({ base00: "#11111b", base03: "#6c7086", base05: "#cdd6f4", base0D: "#89b4fa" })

    FileView {
      id: paletteState
      path: Quickshell.env("HOME") + "/.local/state/theme/palette.json"
      blockLoading: true
    }

    WlrLayershell.namespace: "theme-ui"

    function apply(scheme) {
      Quickshell.execDetached(scheme === "auto" ? ["theme", "auto"] : ["theme", "set", scheme]);
      Qt.quit();
    }

    FileView {
      id: paletteFile
      path: Quickshell.env("HOME") + "/.local/state/theme/palettes.json"
      blockLoading: true
    }

    Component.onCompleted: {
      try {
        try { win.ui = JSON.parse(paletteState.text()); } catch (e2) {}
        win.palettes = JSON.parse(paletteFile.text());
        console.log("theme-ui: loaded", win.palettes.length, "palettes");
      } catch (e) {
        console.log("theme-ui: could not read palettes:", e, "from", paletteFile.path);
      }
    }

    ListView {
      id: list

      anchors.centerIn: parent
      width: parent.width
      height: win.sliceH
      orientation: ListView.Horizontal
      spacing: win.overlap
      clip: true
      focus: true
      keyNavigationEnabled: false

      preferredHighlightBegin: (list.width - win.expandedW) / 2
      preferredHighlightEnd: (list.width + win.expandedW) / 2
      highlightRangeMode: ListView.StrictlyEnforceRange
      highlightMoveVelocity: -1
      highlightMoveDuration: 260

      model: win.palettes

      Component.onCompleted: positionViewAtIndex(currentIndex, ListView.Center)

      delegate: Item {
        id: slice

        required property int index
        required property var modelData

        readonly property bool isCurrent: ListView.isCurrentItem
        readonly property real sk: Math.min(win.skew, Math.max(0, Math.min(width, win.sliceW) - 2))

        width: isCurrent ? win.expandedW : win.sliceW
        height: list.height
        z: isCurrent ? 100 : 50 - Math.abs(index - list.currentIndex)

        Behavior on width {
          NumberAnimation { duration: 260; easing.type: Easing.OutCubic }
        }

        Item {
          id: mask

          anchors.fill: parent
          visible: false
          layer.enabled: true
          layer.smooth: true
          layer.samples: 8

          Shape {
            anchors.fill: parent
            antialiasing: true
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
              fillColor: "white"
              strokeColor: "transparent"
              startX: slice.sk
              startY: 0
              PathLine { x: slice.width; y: 0 }
              PathLine { x: slice.width - slice.sk; y: slice.height }
              PathLine { x: 0; y: slice.height }
              PathLine { x: slice.sk; y: 0 }
            }
          }
        }

        // Create Terminal In View 
        Item {
          id: preview

          anchors.fill: parent
          layer.enabled: true
          layer.smooth: true
          layer.samples: 8
          layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.45
            maskSpreadAtMin: 0.9
          }

          Rectangle {
            anchors.fill: parent
            color: slice.modelData.base00

            Rectangle {
              id: bar
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.top: parent.top
              height: 38
              color: slice.modelData.base01

              Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: slice.sk + 16
                spacing: 8
                Repeater {
                  model: [slice.modelData.base08, slice.modelData.base0A, slice.modelData.base0B]
                  Rectangle { width: 11; height: 11; radius: 6; color: modelData }
                }
              }
            }

            Column {
              anchors.left: parent.left
              anchors.top: bar.bottom
              anchors.leftMargin: slice.sk + 24
              anchors.topMargin: 24
              spacing: 10

              Row {
                spacing: 8
                Text { text: "~/dev/nix"; color: slice.modelData.base0D; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }
                Text { text: "main"; color: slice.modelData.base0E; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }
                Text { text: "✓"; color: slice.modelData.base0B; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }
              }

              Text { text: "$ theme set " + slice.modelData.scheme; color: slice.modelData.base05; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }
              Text { text: "applying palette…"; color: slice.modelData.base04; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }
              Text { text: "warning: 2 files changed"; color: slice.modelData.base09; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }
              Text { text: "error: nothing to commit"; color: slice.modelData.base08; font.family: "FiraCode Nerd Font"; font.pixelSize: 15 }

              Item { width: 1; height: 8 }

              Row {
                spacing: 6
                Repeater {
                  model: [slice.modelData.base08, slice.modelData.base09, slice.modelData.base0A,
                          slice.modelData.base0B, slice.modelData.base0C, slice.modelData.base0D,
                          slice.modelData.base0E, slice.modelData.base0F]
                  Rectangle { width: 34; height: 22; radius: 4; color: modelData }
                }
              }
            }

            Text {
              anchors.left: parent.left
              anchors.bottom: parent.bottom
              anchors.leftMargin: 24
              anchors.bottomMargin: 20
              text: slice.modelData.name
              color: slice.modelData.base05
              font.family: "FiraCode Nerd Font"
              font.pixelSize: 17
              font.bold: true
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: list.currentIndex === slice.index ? win.apply(slice.modelData.scheme) : list.currentIndex = slice.index
        }
      }

      Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
          Qt.quit();
        } else if (event.key === Qt.Key_Left) {
          list.decrementCurrentIndex();
          event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
          list.incrementCurrentIndex();
          event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
          win.apply(win.palettes[list.currentIndex].scheme);
        }
      }
    }
  }
}
