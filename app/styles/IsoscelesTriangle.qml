import QtQuick 2.15
import QtQuick.Shapes 1.15

Shape {
    id: root
    
    readonly property real triangleScale: Math.min(width, height) / (size * 2)
    readonly property point triangleOffset: (width < height) ? Qt.point(0, (height - width)/2) : Qt.point((width - height)/2, 0)
    
    property real size: 10 // 三角形的大小（高度）
    property real radius: 0 // 角的圆角半径
    property real rotation: 0 // 旋转角度
    property color color: "#000000" // 填充颜色
    property color borderColor: "#00000000" // 边框颜色
    property real borderWidth: 0 // 边框宽度
    
    implicitWidth: size * 2
    implicitHeight: size * 2

    layer.enabled: true
    layer.samples: 8

    transform: Rotation {
        origin.x: root.width / 2
        origin.y: root.height / 2
        angle: root.rotation
    }

    ShapePath {
        fillColor: root.color
        strokeColor: root.borderColor
        strokeWidth: root.borderWidth * root.triangleScale
        joinStyle: ShapePath.RoundJoin

        // 三角形的起点, 从左下角开始
        startX: (radius) * triangleScale + triangleOffset.x        
        startY: (size * 2) * triangleScale + triangleOffset.y  

        //底边——右下角
        PathLine {
            x: (size * 2 - radius) * triangleScale + triangleOffset.x
            y:  size * 2 * triangleScale + triangleOffset.y
        }
        PathArc {
            x: size * 2 * triangleScale + triangleOffset.x
            y: (size * 2 - radius) * triangleScale + triangleOffset.y
            radiusX: radius * triangleScale
            radiusY: radius * triangleScale
            direction: PathArc.Counterclockwise
        }

        // 顶点
        PathLine {
            x: (size + radius/2) * triangleScale + triangleOffset.x
            y: (radius/2) * triangleScale + triangleOffset.y
        }
        PathArc {
            x: (size - radius/2) * triangleScale + triangleOffset.x
            y: (radius/2) * triangleScale + triangleOffset.y
            radiusX: radius * triangleScale
            radiusY: radius * triangleScale
            direction: PathArc.Counterclockwise
        }

        // 底边——左下角
        PathLine {
            x: 0 * triangleScale + triangleOffset.x
            y: (size * 2 - radius) * triangleScale + triangleOffset.y
        }
        PathArc {
            x: (radius) * triangleScale + triangleOffset.x  
            y: (size * 2) * triangleScale + triangleOffset.y
            radiusX: radius * triangleScale
            radiusY: radius * triangleScale
            direction: PathArc.Counterclockwise
        }
    }
}