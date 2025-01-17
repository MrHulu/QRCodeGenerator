import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.1
import QtGraphicalEffects 1.15
import Qrcodeworker 1.0
import "layout"
import "styles"

ApplicationWindow {
    visible: true
    minimumWidth: 1024
    minimumHeight: 800
    width: 1024
    height: 800
    title: "QR Code Generator"
    QrMenu {
        id: qrMenu
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        onQrCodeTypeChanged: {
            label.text = type
            loader.qrcontent = ""
        }
    }
    
    Item {
        anchors.left: parent.left
        anchors.right: previews.left
        anchors.top: qrMenu.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 20
        anchors.rightMargin: 60
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 20
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    id: label
                    text: "文本"
                    font.bold: true
                    font.pixelSize: 24
                    color: Themes.accent
                }
                Loader {
                    id: loader
                    anchors.top: label.bottom
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    property string qrcontent: ""
                    onQrcontentChanged: { if(qrcodegenrator) qrcodegenrator.ready = false }
                    sourceComponent: {
                        switch(qrMenu.currentIndex) {
                        case 0: return textComponent
                        case 1: return linkComponent
                        // case 2: return emailComponent
                        case 3: return telComponent
                        // case 4: return wifiComponent
                        default: return todoComponent
                        }
                    }
                }
                Component {
                    id: textComponent
                    TextContent {
                        id: textContent
                        onTextChanged: loader.qrcontent = textContent.text
                    }
                }
                Component {
                    id: linkComponent
                    HttpContent {
                        id: httpContent
                        onTextChanged: loader.qrcontent = httpContent.text
                    }
                }
                Component {
                    id: telComponent
                    TelContent {
                        id: telContent
                        onTextChanged: loader.qrcontent = telContent.text
                    }
                }
                
                Component {
                    id: todoComponent
                    Control {
                        implicitHeight: 300
                        implicitWidth: 400
                        padding: 20
                        Label {
                            anchors.centerIn: parent
                            text: "抱歉，该功能作者正在努力开发中..."
                            font.bold: true
                            font.pixelSize: 24
                        }
                        background: Rectangle {
                            anchors.fill: parent
                            radius: 10
                            layer.enabled: true
                            layer.effect: DropShadow {
                                verticalOffset: 1
                                horizontalOffset: 1
                                radius: 8
                                samples: 17
                                color: "#80000000"
                            }
                        }
                    }
                }
                
            }
            QrConfig {
                id: qrConfig
                Layout.preferredHeight: 400
                Layout.fillWidth: true
                // Layout.fillHeight: true
            }
        }
    }

    QrPreviews {
        id: previews
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        image: ""
        enabled: loader.qrcontent !== ""
        isReady: qrcodegenrator ? qrcodegenrator.ready : false
        onPreviews: {
            qrcodegenrator.data = loader.qrcontent
            qrcodegenrator.generate()
            previews.image = "%1/Hulu/temp.png".arg(StandardPaths.writableLocation(StandardPaths.TempLocation))
        }
        onSave: {
            qrcodegenrator.save(path)
        }
    }
}