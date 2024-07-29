import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.15

T.Switch {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    padding: 0
    spacing: 6
    opacity: enabled ? 1 : 0.4

    
    property alias label: checkLabel
    property alias handle: handle
    property color upColor: "#FFd0d0d0"
    property color downColor: "#FF338BFF"
    


    indicator: Item {
        implicitWidth: 34
        implicitHeight: 21

        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        PaddedRectangle {
            anchors.fill: parent
            anchors.topMargin: 1
            anchors.bottomMargin: 1

            radius: 12
            leftPadding: 0
            rightPadding: 0
            padding: 1
            color: control.checked ? downColor : upColor
            // layer.enabled: control.checked
            // layer.effect: LinearGradient {
            //     start: Qt.point(0, 0)
            //     end: Qt.point(width, 0)
            //     gradient: Gradient {
            //         GradientStop { position: 0.0; color: "#FFEF791B" }
            //         GradientStop { position: 1.0; color: "#FFDB511F" }
            //     }
            // }
        }
        Rectangle {
            id: handle
            x: Math.max(0, Math.min(parent.width - width, control.visualPosition * parent.width - (width / 2)))
            y: (parent.height - height) / 2
            width: 17
            height: 17
            radius: 16
            color: "#FFFFFFFF"
            border.width: 0.5
            border.color: "#0A000000"

            layer.enabled: true
            layer.effect: DropShadow {
                verticalOffset: 0
                horizontalOffset: 2
                radius: 3
                samples: 10
                color: "#0F000000"
            }

            Behavior on x {
                enabled: !control.down
                SmoothedAnimation { velocity: 200 }
            }
        }
    }

    contentItem: CheckLabel {
        id: checkLabel
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

        text: control.text
        font: control.font
        color: "black"
    }
}
