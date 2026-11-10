pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property QtObject rounding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int largeIncreased: 20
        readonly property int extraLarge: 28
        readonly property int extraLargeIncreased: 32
        readonly property int full: 1000
    }

    readonly property QtObject spacing: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 28
    }

    readonly property QtObject padding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 28
    }

    readonly property QtObject sizes: QtObject {
        readonly property int itemWidth: 600
        readonly property int itemHeight: 57
    }

    readonly property QtObject font: QtObject {
        readonly property string family: "FiraCode Nerd Font"
        readonly property string iconFamily: "Material Symbols Rounded"

        readonly property QtObject body: QtObject {
            readonly property font small: Qt.font({ family: "FiraCode Nerd Font", pointSize: 10 })
            readonly property font medium: Qt.font({ family: "FiraCode Nerd Font", pointSize: 12 })
            readonly property font large: Qt.font({ family: "FiraCode Nerd Font", pointSize: 13, weight: Font.Medium })
        }

        readonly property QtObject label: QtObject {
            readonly property font medium: Qt.font({ family: "FiraCode Nerd Font", pointSize: 10, weight: Font.Medium })
        }

        readonly property QtObject icon: QtObject {
            readonly property int small: 15
            readonly property int medium: 18
            readonly property int large: 22
            readonly property int extraLarge: 28
        }
    }

    readonly property QtObject anim: QtObject {
        readonly property QtObject durations: QtObject {
            readonly property int small: 200
            readonly property int normal: 400
            readonly property int large: 600
            readonly property int extraLarge: 1000
            readonly property int expressiveFastSpatial: 350
            readonly property int expressiveDefaultSpatial: 500
            readonly property int expressiveSlowSpatial: 650
            readonly property int expressiveFastEffects: 150
            readonly property int expressiveDefaultEffects: 200
            readonly property int expressiveSlowEffects: 300
        }

        readonly property QtObject curves: QtObject {
            readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
            readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
            readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
            readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
            readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
            readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
            readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
            readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
            readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1]
            readonly property list<real> expressiveFastEffects: [0.31, 0.94, 0.34, 1, 1, 1]
            readonly property list<real> expressiveDefaultEffects: [0.34, 0.8, 0.34, 1, 1, 1]
            readonly property list<real> expressiveSlowEffects: [0.34, 0.88, 0.34, 1, 1, 1]
        }
    }
}
