import QtQuick
import "../theme"

Text {
    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Colours.palette.m3onSurface
    font: Tokens.font.body.small

    Behavior on color {
        CAnim {}
    }
}
