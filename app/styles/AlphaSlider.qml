// This is a custom slider that displays the alpha of the color that the slider represents.
// The alpha is displayed as a color gradient on the slider handle.
// Depending CircularRing.qml

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.15

T.Slider {
    id: control

    required property color color
    property int radius: Math.min(width, height) / 2

    from: 0
    to: 1
    value: 1

    width: 200
    height: 12
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)
    leftInset: horizontal ? ring.outerRadius : privateProperties.barBreadth
    rightInset:horizontal ? ring.outerRadius : privateProperties.barBreadth
    topInset: horizontal ? privateProperties.barBreadth : ring.outerRadius
    bottomInset: horizontal ? privateProperties.barBreadth : ring.outerRadius
    opacity: enabled ? 1 :0.4

    QtObject {
        id: privateProperties
        property real barBreadth: Math.ceil((ring.outerRadius - ring.innerRadius) * 0.3)
    }

    handle: CircleRing {
        id: ring

        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))

        outerRadius: Math.max(1, Math.min(control.width, control.height) / 2)
        innerRadius: Math.max(1, Math.min(control.width, control.height) / 3)
        ringLineWidth: 0.5
    }

    background: Item {
        scale: control.horizontal && control.mirrored ? -1 : 1

        Image{
            anchors.fill: parent
            source: "qrc:/resources/images/color_transparent_rect.png"
        }

        Rectangle {
            anchors.fill: parent
            x: control.leftInset
            y: control.topInset
            width: control.availableWidth - control.leftInset - control.rightInset
            height: control.availableHeight - control.topInset - control.bottomInset
            radius: control.radius
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: control.color }
            }
        }
    }
}
