import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../styles"
import "../components"
import Qrcodeworker 1.0

Item {
    id: control

    enum Type {
        SolidType = 0,
        GradientType = 1,
        TransparentType = 2,
        ImageType = 3
    }
    
    GradientBackground { id: g_background; colors: [colorRect.color, gradient_colorRect.color] }
    ImageBackground { id: i_background; path: "" }
    TransparentBackground { id: t_background }

    property GradientBackground gradientBackground: qrcodegenrator.backgroundStrategy instanceof GradientBackground ? qrcodegenrator.backgroundStrategy : g_background 

    property TransparentBackground transparentBackground: qrcodegenrator.backgroundStrategy instanceof TransparentBackground ? qrcodegenrator.backgroundStrategy : t_background

    property ImageBackground imageBackground: qrcodegenrator.backgroundStrategy instanceof ImageBackground ? qrcodegenrator.backgroundStrategy : i_background
    
    ColorGenerator {
        id: colorGenerator
        alphaEnabled: false
        onAccepted: {
            if(parent === colorRect) {
                colorRect.color = color
                colorLabel.text = rgba
            }
            else if(parent === gradient_colorRect) {
                gradient_colorRect.color = color
                gradient_colorLabel.text = rgba
            }
            if(type.currentIndex !== 0) {
                qrcodegenrator.background_colors = [colorRect.color, gradient_colorRect.color]
                gradientBackground.colors = [colorRect.color, gradient_colorRect.color]
            }
            else {
                qrcodegenrator.background_colors = [colorRect.color]
            }
        }
    }
    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        Label {
            text: "背景色"
            font.bold: true
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            MouseArea {
                id: colorRect_mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    colorGenerator.parent = colorRect
                    colorGenerator.y = colorRect.height
                    colorGenerator.open()
                }
                cursorShape: Qt.PointingHandCursor
            }
            Rectangle {
                id: colorRect
                anchors.verticalCenter: parent.verticalCenter
                height: 24
                width: 24
                radius: colorRect_mouseArea.containsMouse ? 8 : 4
                border.color: "#20000000"
                border.width: 1
                color: qrcodegenrator.background_colors.length > 0 ? qrcodegenrator.background_colors[0] : "transparent"
            }
            Label {
                id: colorLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: colorRect.right
                anchors.leftMargin: 8
                font.pixelSize: 12
                font.bold: true
                text: colorRect.color 
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            Control {
                id: gradient_color
                height: parent.height
                width: gradient_colorRect.width + gradient_colorLabel.width + 16
                opacity: type.currentIndex === 0 ? 0 : 1
                NumberAnimation on opacity {
                    running: type.currentIndex !== 0
                    from: 0;to: 1
                    easing.type: Easing.InOutQuad
                    duration: 300
                }
                MouseArea {
                    id: gradient_colorRect_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        colorGenerator.parent = gradient_colorRect
                        colorGenerator.y = -gradient_colorRect.height - colorGenerator.height
                        colorGenerator.open()
                    }
                    cursorShape: Qt.PointingHandCursor
                }
                Rectangle {
                    id: gradient_colorRect
                    anchors.verticalCenter: parent.verticalCenter
                    height: 24
                    width: 24
                    radius: gradient_colorRect_mouseArea.containsMouse ? 8 : 4
                    border.color: "#20000000"
                    border.width: 1
                    color: qrcodegenrator.background_colors.length > 1 ? qrcodegenrator.background_colors[1] : "transparent"
                }
                Label {
                    id: gradient_colorLabel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: gradient_colorRect.right
                    width: implicitWidth
                    anchors.leftMargin: 8
                    font.pixelSize: 12
                    font.bold: true
                    text: gradient_colorRect.color
                }
            }
            ComboBox {
                id: type
                anchors.verticalCenter: parent.verticalCenter
                readonly property int pos : gradient_color.width + gradient_colorLabel.width + 32
                x: pos//checked ? pos : 0
                NumberAnimation on x {
                    running: type.currentIndex !== 0
                    from: 0; to: type.pos
                    easing.type: Easing.InOutElastic
                    duration: 300
                }
                NumberAnimation on x {
                    running: type.currentIndex === 0
                    from: type.pos; to: 0
                    easing.type: Easing.InOutElastic
                    duration: 300
                }
                textRole: "text"
                valueRole: "value"
                model: [
                    {text: "纯色", value: QrBackgroundConfig.Type.SolidType},
                    {text: "渐变", value: QrBackgroundConfig.Type.GradientType},
                    {text: "透明", value: QrBackgroundConfig.Type.TransparentType},
                    {text: "图片", value: QrBackgroundConfig.Type.ImageType}
                ]
                // currentIndex: {
                //     if(qrcodegenrator.backgroundStrategy instanceof GradientBackground) return 1
                //     else if(qrcodegenrator.backgroundStrategy instanceof TransparentBackground) return 2
                //     else if(qrcodegenrator.backgroundStrategy instanceof ImageBackground) return 3
                //     else return 0
                // }
                onCurrentIndexChanged: {
                    switch(type.currentIndex) {
                        case QrBackgroundConfig.Type.SolidType:
                            qrcodegenrator.background_colors = [colorRect.color]
                            qrcodegenrator.backgroundStrategy = null
                            break
                        case QrBackgroundConfig.Type.GradientType:
                            qrcodegenrator.background_colors = [colorRect.color, gradient_colorRect.color]
                            qrcodegenrator.backgroundStrategy = control.gradientBackground
                            break
                        case QrBackgroundConfig.Type.TransparentType:
                            qrcodegenrator.backgroundStrategy = control.transparentBackground
                            break
                        case QrBackgroundConfig.Type.ImageType:
                            qrcodegenrator.backgroundStrategy = control.imageBackground
                            break
                    }
                    currentIndex = Qt.binding(()=> {
                        if(qrcodegenrator.backgroundStrategy instanceof GradientBackground) return 1
                        else if(qrcodegenrator.backgroundStrategy instanceof TransparentBackground) return 2
                        else if(qrcodegenrator.backgroundStrategy instanceof ImageBackground) return 3
                        else return 0
                    })
                }
            }
        }
    }// ColumnLayout
}