import QtQuick
import "../theme"

StyledText {
    property real fill
    property int size: Tokens.font.icon.small
    property int weight: Font.Normal

    font.family: Tokens.font.iconFamily
    font.pointSize: size
    font.weight: weight
    font.variableAxes: ({
            FILL: fill,
            GRAD: -25,
            opsz: size,
            wght: weight
        })
}
