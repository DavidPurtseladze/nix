import QtQuick
import "../theme"

Item {
    id: slider

    property real value: 0
    property bool muted: false

    readonly property alias held: drag.active

    signal moved(real value)

    implicitHeight: 18

    function pick(x) {
        slider.moved(Math.max(0, Math.min(1, x / slider.width)));
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 4
        radius: 2
        color: Theme.track

        Rectangle {
            width: parent.width * (slider.muted ? 0 : slider.value)
            height: parent.height
            radius: parent.radius
            color: slider.muted ? Theme.textDim : Theme.text

            Behavior on width {
                enabled: !drag.active
                NumberAnimation { duration: 120 }
            }
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: point => slider.pick(point.position.x)
    }

    DragHandler {
        id: drag

        target: null
        xAxis.enabled: true
        yAxis.enabled: false

        onCentroidChanged: if (active) slider.pick(centroid.position.x)
    }
}
