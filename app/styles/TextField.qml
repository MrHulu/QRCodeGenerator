import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

T.TextField {
    id: control
    signal rejectInput()

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)
    rightPadding: padding
    leftPadding: 8
    opacity: enabled ? 0.85 : 0.4

    selectByMouse: true
    selectionColor: control.palette.highlight
    selectedTextColor: control.palette.highlightedText
    placeholderTextColor: Color.transparent(control.color, 0.5)
    verticalAlignment: TextInput.AlignVCenter
    horizontalAlignment: TextInput.AlignHCenter
    font.pixelSize: 12
    font.weight: Font.Bold

    color: "#FF404347"
    property color activeColor: "#FF66B8FF"
    property int radius: 2
    

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: "#40404347"
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: Rectangle {
        implicitWidth: 48
        implicitHeight: 24
        radius: control.radius
        border.width: control.activeFocus ? 2 : 1
        color: "transparent"
        border.color: {
            if(control.activeFocus || control.hovered)
                if (control.acceptableInput)
                    return Qt.rgba(control.activeColor.r/2, control.activeColor.g, control.activeColor.b, control.activeColor.a)
                else{
                    rejectInput()
                    return "red"
                }
            else
                return Qt.rgba(control.color.r, control.color.g, control.color.b, 0.5)
        }
    }
}
