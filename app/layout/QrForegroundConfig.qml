import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../styles"
import "../components"
import Qrcodeworker 1.0

Item {
    id: control
    
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
            if(isGradient.checked) {
                qrcodegenrator.foreground_colors = [colorRect.color, gradient_colorRect.color]
            }
            else {
                qrcodegenrator.foreground_colors = [colorRect.color]
            }
        }
    }
    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        Label {
            text: "前景色"
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
                    colorGenerator.show(colorRect)
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
                color: qrcodegenrator.foreground_colors.length > 0 ? qrcodegenrator.foreground_colors[0] : "transparent"
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
                opacity: isGradient.checked ? 1 : 0
                NumberAnimation on opacity {
                    running: isGradient.checked
                    from: 0;to: 1
                    easing.type: Easing.InOutQuad
                    duration: 300
                }
                MouseArea {
                    id: gradient_colorRect_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        colorGenerator.show(gradient_colorRect)
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
                    color: qrcodegenrator.foreground_colors.length > 1 ? qrcodegenrator.foreground_colors[1] : "transparent"
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
            Switch {
                id: isGradient
                anchors.verticalCenter: parent.verticalCenter
                readonly property int pos : gradient_color.width + gradient_colorLabel.width + 32
                x: checked ? pos : 0
                NumberAnimation on x {
                    running: isGradient.checked
                    from: 0; to: isGradient.pos
                    easing.type: Easing.InOutElastic
                    duration: 300
                }
                NumberAnimation on x {
                    running: !isGradient.checked
                    from: isGradient.pos; to: 0
                    easing.type: Easing.InOutElastic
                    duration: 300
                }
                text: "渐变"
                checked: qrcodegenrator.foreground_colors.length > 1
                onToggled: {
                    if(checked) {
                        qrcodegenrator.foreground_colors = [colorRect.color, gradient_colorRect.color]
                    }
                    else {
                        qrcodegenrator.foreground_colors = [colorRect.color]
                    }
                    checked = Qt.binding(()=>qrcodegenrator.foreground_colors.length > 1)
                }
            }
        }
    }// ColumnLayout
}