import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
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
            if(type.currentIndex !== QrBackgroundConfig.Type.SolidType) {
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
                id: image_upload
                height: parent.height
                width: upload_button.width
                visible: type.currentIndex === QrBackgroundConfig.Type.ImageType
                GradientButton {
                    id: upload_button
                    anchors.verticalCenter: parent.verticalCenter
                    text: "上传"
                    onClicked: fileDialog.open()
                }
                FileDialog {
                    id: fileDialog
                    selectMultiple: false
                    selectFolder: false
                    nameFilters: ["Images (*.png *.jpg *.jpeg *.svg)"]
                    onAccepted: {
                        var path = fileDialog.fileUrl
                        if(path)  imageBackground.path = path 
                    }
                }
            }
            Control {
                id: gradient_color
                height: parent.height
                width: gradient_colorRect.width + gradient_colorLabel.width + 16
                visible: type.currentIndex === QrBackgroundConfig.Type.GradientType
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
                readonly property int pos:  {
                    if(type.currentIndex === QrBackgroundConfig.Type.GradientType) return gradient_color.width + 32
                    else if(type.currentIndex === QrBackgroundConfig.Type.ImageType) return image_upload.width + 32
                    else return 0
                }
                x: pos//checked ? pos : 0
                NumberAnimation on x {
                    running: (type.currentIndex === QrBackgroundConfig.Type.GradientType) || (type.currentIndex === QrBackgroundConfig.Type.ImageType)
                    from: 0; to: type.pos
                    easing.type: Easing.InOutElastic
                    duration: 300
                }
                NumberAnimation on x {
                    running: !((type.currentIndex === QrBackgroundConfig.Type.GradientType) || (type.currentIndex === QrBackgroundConfig.Type.ImageType))
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