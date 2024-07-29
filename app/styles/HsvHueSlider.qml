// This is a custom slider that displays the hue of the color that the slider represents.
// The hue is displayed as a color gradient on the slider handle.
// The slider handle is a ring that displays the hue of the color that the slider represents.
// Depending CircularRing.qml

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.15

T.Slider {
    id: control

    readonly property real hsvHue: (value - from) / (to - from)
    property int radius: Math.min(width, height) / 2

    from: 0
    to: 1
    value: 0.5

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

        function toHueColor(hsvHueValue) {
            let v = 1.0 - hsvHueValue;
            if (0.0 <= v && v < 0.16) {
                return Qt.rgba(1.0, 0.0, v / 0.16, 1.0);
            } else if (0.16 <= v && v < 0.33) {
                return Qt.rgba(1.0 - (v - 0.16) / 0.17, 0.0, 1.0, 1.0);
            } else if (0.33 <= v && v < 0.5) {
                return Qt.rgba(0.0, ((v - 0.33) / 0.17), 1.0, 1.0);
            } else if (0.5 <= v && v < 0.76) {
                return Qt.rgba(0.0, 1.0, 1.0 - (v - 0.5) / 0.26, 1.0);
            } else if (0.76 <= v && v < 0.85) {
                return Qt.rgba((v - 0.76) / 0.09, 1.0, 0.0, 1.0);
            } else if (0.85 <= v && v <= 1.0) {
                return Qt.rgba(1.0, 1.0 - (v - 0.85) / 0.15, 0.0, 1.0);
            } else {
                return "red";
            }
        }
    }

    handle: CircleRing {
        id: ring

        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))

        outerRadius: Math.max(1, Math.min(control.width, control.height) / 2)
        innerRadius: Math.max(1, Math.min(control.width, control.height) / 3)
        ringLineWidth: 0.5
        innerColor: privateProperties.toHueColor(control.orientation === Qt.Vertical ? 1-control.hsvHue : control.hsvHue)
    }

    background: Item {
        scale: control.horizontal && control.mirrored ? -1 : 1

        Rectangle {
            anchors.fill: parent
            x: control.leftInset
            y: control.topInset
            width: control.availableWidth - control.leftInset - control.rightInset
            height: control.availableHeight - control.topInset - control.bottomInset
            radius: control.radius
            gradient: Gradient {
                orientation: control.orientation
                GradientStop { position: 0.0; color: "#FE0700" }
                GradientStop { position: 0.17; color: "#FFF900" }
                GradientStop { position: 0.33; color: "#09FE00" }
                GradientStop { position: 0.5; color: "#10FFF6" }
                GradientStop { position: 0.67; color: "#1101FF" }
                GradientStop { position: 0.83; color: "#FF00F2" }
                GradientStop { position: 1.0; color: "#FE0205" }
            }
        }
    }
}
