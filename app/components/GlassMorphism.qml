import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root
    // 可自定义的属性
    required property var backgroundObject
    property real glassOpacity: 0.2
    property real blurRadius: 40
    property real cornerRadius: 20
    property color glassColor: "white"
    property real shadowRadius: 8
    property color shadowColor: "#80000000"
    property real shadowOffsetY: 4
    // clip: true
    width: 700
    height: 375
    
    Rectangle {
        id: glassRect

        // 默认大小，可在使用时覆盖
        color: "transparent"
        anchors.fill: parent
        radius: root.cornerRadius

        // 模糊背景
        Rectangle {
            id: blurredBackground
            anchors.fill: parent
            color: Qt.rgba(root.glassColor.r, root.glassColor.g, root.glassColor.b, root.glassOpacity)
            radius: parent.radius
            
            ShaderEffectSource {
                id: blurEffectSource
                anchors.fill: parent
                sourceItem: root.backgroundObject
                // hideSource: true
                // smooth: true
                sourceRect: Qt.rect(root.x, root.y, root.width, root.height)  
            }
            FastBlur {
                anchors.fill: parent
                source: blurEffectSource
                radius: root.blurRadius
            }

        }

        // 阴影效果
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: root.shadowOffsetY
            radius: root.shadowRadius
            samples: 17
            color: root.shadowColor
        }
    }
}

// 示例
    
// Item {
//     width: 700
//     height: 375
//     anchors.centerIn: parent

//     Image {
//         id: backgroundImage
//         source: "%1/Hulu/temp.png".arg(StandardPaths.writableLocation(StandardPaths.TempLocation))
//         anchors.fill: parent
//         fillMode: Image.PreserveAspectCrop
//     }
//     GlassMorphism {
//         id: glassRect
//         width: 600
//         height: 300
//         anchors.centerIn: parent
//         backgroundObject: backgroundImage
//         glassOpacity: 0.25
//         blurRadius: 40
//         cornerRadius: 25

//         Column {
//             anchors.fill: parent
//             spacing: 10

//             Text {
//                 text: "Glass Morphism"
//                 color: "white"
//                 font.pixelSize: 24
//                 font.bold: true
//             }

//             Text {
//                 text: "This is a customizable glass morphism component."
//                 color: "white"
//                 wrapMode: Text.WordWrap
//                 width: parent.width
//             }
//         }
//     }
// }