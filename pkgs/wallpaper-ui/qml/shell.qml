import QtQuick 
import QtQuick.Shapes
import QtQuick.Effects
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
  PanelWindow {
    id: win

    property string dir: "/etc/nixos/config/assets/wallpapers"

    property int sliceW: 140
    property int expandedW: 920
    property int sliceH: 520
    property int overlap: -30
    property int skew: 35

    property bool filtering: false
    property string query: ""

    function nameFilters() {
      const q = (filtering && query.length > 0) ? "*" + query + "*" : "*";
      return [q + ".jpg", q + ".jpeg", q + ".png", q + ".gif"];
    }

    property var ui: ({ base00: "#11111b", base03: "#6c7086", base05: "#cdd6f4", base0D: "#89b4fa" })

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    color: win.ui.base00 + "cc"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive 
    WlrLayershell.namespace: "wallpaper-ui"

    FileView {
      id: paletteState
      path: Quickshell.env("HOME") + "/.local/state/theme/palette.json"
      blockLoading: true
    }

    Component.onCompleted: {
      try {
        win.ui = JSON.parse(paletteState.text());
      } catch (e) {
        console.log("wallpaper-ui: no palette yet, using defaults");
      }
    }

    function apply(path) {
      Quickshell.execDetached(["sh", "-c",
        "awww img '" + path + "' --transition-type grow --transition-pos top-left --transition-duration 1 && theme auto '" + path + "'"]);
      Qt.quit();
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

      model: FolderListModel {
        folder: "file://" + win.dir
        nameFilters: win.nameFilters()
        caseSensitive: false
        showDirs: false
        sortField: FolderListModel.Name
      }

      preferredHighlightBegin: (list.width - win.expandedW) / 2
      preferredHighlightEnd: (list.width + win.expandedW) / 2
      highlightRangeMode: ListView.StrictlyEnforceRange
      highlightMoveDuration: 260

      keyNavigationEnabled: false

      delegate: Item {
        id: slice

        required property int index
        required property string filePath
        required property url fileUrl

        readonly property bool isCurrent: ListView.isCurrentItem
        readonly property real sk: Math.min(win.skew, Math.max(0, Math.min(width, win.sliceW) - 2))

        width: isCurrent ? win.expandedW : win.sliceW
        height: list.height
        z: isCurrent ? 100 : 50 - Math.abs(index - list.currentIndex)

        // Create Active Effect On Image 
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

            // Create a lean effect
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

        // Keep the image straight to keep it undistorted
        Image {
          id: shot

          anchors.fill: parent
          source: fileUrl
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          cache: true
          sourceSize.width: win.expandedW
          layer.enabled: true
          layer.smooth: true
          layer.samples: 8
          layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.45
            maskSpreadAtMin: 0.9
          }
        }

        // Add border on image
        Shape {
          anchors.fill: parent
          antialiasing: true
          preferredRendererType: Shape.CurveRenderer
          layer.enabled: true
          layer.samples: 8

          ShapePath {
            fillColor: "transparent"
            strokeColor: slice.isCurrent ? win.ui.base05 : win.ui.base03
            strokeWidth: 2
            startX: slice.sk + 1
            startY: 1
            PathLine { x: slice.width - 1; y: 1 }
            PathLine { x: slice.width - slice.sk - 1; y: slice.height - 1 }
            PathLine { x: 1; y: slice.height - 1 }
            PathLine { x: slice.sk + 1; y: 1 }
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: list.currentIndex === slice.index ? win.apply(slice.filePath) : list.currentIndex = slice.index
        }
      }

      Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
          if (win.filtering) {
            win.filtering = false;
            win.query = "";
          } else {
            Qt.quit();
          }
          event.accepted = true;
        } else if (event.key === Qt.Key_Backspace && win.filtering) {
          win.query = win.query.slice(0, -1);
          if (win.query.length === 0)
            win.filtering = false;
          list.currentIndex = 0;
          event.accepted = true;
        } else if (!win.filtering && event.text === "/") {
          win.filtering = true;
          win.query = "";
          event.accepted = true;
        } else if (win.filtering && event.text.length === 1 && event.text >= " ") {
          win.query += event.text;
          list.currentIndex = 0;
          event.accepted = true;
        } else if (event.key === Qt.Key_Left) {
          list.decrementCurrentIndex();
          event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
          list.incrementCurrentIndex();
          event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
          win.apply(list.model.get(list.currentIndex, "filePath"));
        }
      }
    }

    // Filtering Text 
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 64
      visible: win.filtering
      color: win.ui.base05
      font.family: "FiraCode Nerd Font"
      font.pixelSize: 16
      text: "/" + win.query
    }
  }
}
