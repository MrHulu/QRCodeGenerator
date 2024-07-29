import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.15

Shape {
    readonly property real ringScale: Math.min(width, height) / (outerRadius * 2) // 圆环缩放比例
    readonly property point ringOffset: (width < height) ? Qt.point(0, (height - width)/2) : Qt.point((width - height)/2, 0) // 圆环偏移量
    
    property real ringLineWidth: 0.2 // 圆环线宽
    property real innerRadius: 4    // 内圆半径
    property real outerRadius: 6    // 外圆半径
    property color ringColor: "#FFFFFF" // 圆环颜色
    property color innerColor: "transparent" // 内圆颜色
    
    implicitWidth: outerRadius * 2
    implicitHeight: outerRadius * 2


    layer.enabled: true
    layer.samples: 32

    ShapePath {
        fillColor: innerColor
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.MiterJoin

        startX: outerRadius * ringScale + ringOffset.x
        startY: outerRadius * ringScale + ringOffset.y

        PathAngleArc {
            centerX: outerRadius * ringScale + ringOffset.x
            centerY: outerRadius * ringScale + ringOffset.y
            moveToStart: true
            radiusX: innerRadius * ringScale
            radiusY: innerRadius * ringScale
            startAngle: 0
            sweepAngle: 360
        }
    }
    ShapePath {
        strokeColor: "#80000000"
        strokeWidth: ringLineWidth
        fillColor: ringColor
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.MiterJoin

        startX: outerRadius * ringScale + ringOffset.x
        startY: outerRadius * ringScale + ringOffset.y

        PathAngleArc {
            centerX: outerRadius * ringScale + ringOffset.x
            centerY: outerRadius * ringScale + ringOffset.y
            moveToStart: true
            radiusX: outerRadius * ringScale
            radiusY: outerRadius * ringScale
            startAngle: 0
            sweepAngle: 360
        }
        PathAngleArc {
            centerX: outerRadius * ringScale + ringOffset.x
            centerY: outerRadius * ringScale + ringOffset.y
            moveToStart: true
            radiusX: innerRadius * ringScale
            radiusY: innerRadius * ringScale
            startAngle: 0
            sweepAngle: 360
        }
    }
}
