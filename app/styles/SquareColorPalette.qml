import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.14

Item {
    id: root
    required property real hsvHue // 颜色色相 0~1
    readonly property alias hsvSaturation: colorPickerCursor.hsvSaturation // 颜色饱和度 0~1
    readonly property alias hsvValue: colorPickerCursor.hsvValue // 颜色明度 0~1
    property alias colorPickerCursor: colorPickerCursor // 颜色选择器光标圆环
    property real radius: 4

    function getColor() { return Qt.hsva(hsvHue, hsvSaturation, hsvValue, 1) }
    function setColor(color) {
        colorPickerCursor.setHsvSaturation(color.hsvSaturation)
        colorPickerCursor.setHsvValue(color.hsvValue)
        hsvHue = color.hsvHue
    }
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
    signal moved()

    implicitWidth: 200
    implicitHeight: 200
    clip: true

    // background
    Rectangle {
        y: root.height
        x: 0
        height: root.width
        width: root.height
        rotation: -90
        radius: root.radius
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0.0; color: "white" }
            GradientStop { position: 1.0; color: root.toHueColor(root.hsvHue) }
        }
    }

    Rectangle {
        x: 0
        y: 0
        width: root.width
        height: root.height
        radius: root.radius
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#ff000000" }
            GradientStop { position: 0.0; color: "#00000000" }
        }
    }

    onWidthChanged: colorPickerCursor.updatePosition()
    onHeightChanged: colorPickerCursor.updatePosition()
    Component.onCompleted: colorPickerCursor.updatePosition()
    CircleRing {
        id: colorPickerCursor
        readonly property real hsvSaturation: (x + width / 2) / root.width
        readonly property real hsvValue: 1 - (y + height / 2) / root.height
        function setHsvSaturation(s) { x = Qt.binding(()=>s * root.width - width / 2) }
        function setHsvValue(v) { y = Qt.binding(()=>(1-v) * root.height - height / 2) }
        x: (root.width - width) / 2
        y: (root.height - height) / 2

        function updatePosition() {
            x = hsvSaturation * root.width - width / 2
            y = (1 - hsvValue) * root.height - height / 2
        }
        outerRadius: Math.max(Math.min(root.width, root.height) / 50, 6)
        innerRadius: outerRadius - 2
        ringLineWidth: 0.5
    }

    PointHandler {
        acceptedButtons: Qt.LeftButton
        onPointChanged: {
            if (active) {
                const pos = point.position
                colorPickerCursor.x = Math.min(Math.max(0, pos.x), root.width) - (colorPickerCursor.width / 2)
                colorPickerCursor.y = Math.min(Math.max(0, pos.y), root.height) - (colorPickerCursor.height / 2)
                root.moved()
            }
        }
    }
}
