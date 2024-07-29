import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.15


T.Button {
    id: control

    enum Style {
        ButtonNormal = 1,
        ButtonLineGradient,
        ButtonRadialGradient
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 6

    property string buttonText: control.text
    property int radius: 2
    property int useStyle: GradientButton.Style.ButtonNormal
    property color textColor: "#FFFFFFFF"
    property color buttonColor: "#FF66B8FF"
    // property var buttonColors: ["#FF66B8FF", "#FF33B8FF"]
    property color buttonColor2: "#FF338BFF"

    contentItem: Label {
        height: control.height * 0.9
        font.pixelSize: control.height * 0.38
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1 : 0.6
        color: control.textColor
        text: control.text
    }

    background: Rectangle {
        id: backgroundRect
        implicitWidth: 48
        implicitHeight: 24
        radius: control.radius
        opacity: control.enabled ? 1 : 0.4
        function getLightColor() {
            if(control.pressed)
                return control.buttonColor2
            if(control.hovered)
                return control.buttonColor
            else
                return control.buttonColor
        }
        
        function getDarkerColor() {
            if(control.pressed)
                return control.buttonColor2
            if(control.hovered)
                return control.buttonColor
            else
                return control.buttonColor2
        }
        Component {
            id: fillGradient
            LinearGradient {
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: backgroundRect.getDarkerColor() }
                    GradientStop { position: 1.0; color: backgroundRect.getDarkerColor() }
                }
            }
        }
        Component {
            id: lineGradient
            LinearGradient {
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)
                gradient: Gradient {
                    // stops: control.buttonColors.map((c, index, arr) => {
                    //     var pos = index / ((arr.length - 1) > 0 ? arr.length-1 : 1)
                    //     var str = '
                    //         import QtQuick 2.15;
                    //         GradientStop { position: ' + pos +'; color: "' + c + '" }'
                    //         console.log(c, pos, str)
                    //     return Qt.createQmlObject(str, parent)
                    // })
                    GradientStop { position: 0.0; color: backgroundRect.getLightColor() }
                    GradientStop { position: 1.0; color: backgroundRect.getDarkerColor() }
                }
            }
        }
        Component {
            id: radialGradient
            RadialGradient {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: backgroundRect.getLightColor() }
                    GradientStop { position: 1.0; color: backgroundRect.getDarkerColor() }
                }
            }
        }
        layer.enabled: true
        layer.effect: {
            switch(control.useStyle) {
                case GradientButton.Style.ButtonNormal:
                    return fillGradient
                case GradientButton.Style.ButtonLineGradient:
                    return lineGradient
                case GradientButton.Style.ButtonRadialGradient:
                    return radialGradient
                default:
                    return null
            }
        }
    }
    layer.enabled: true
    layer.effect: DropShadow {
        verticalOffset: 0
        horizontalOffset: 0
        radius: 8
        samples: 16
        color: "#CC4C99FF"
    }
}
