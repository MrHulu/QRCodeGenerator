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
            console.log("onQrCodeType: ", type)
        }
    }

    QrConfig {
        id: qrConfig
        anchors.left: parent.left
        anchors.right: previews.left
        anchors.top: qrMenu.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 20
        anchors.rightMargin: 60
    }

    QrPreviews {
        id: previews
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        image: ""
        isOk: qrcodegenrator ? qrcodegenrator.is_ok : false
        onPreviews: {
            qrcodegenrator.data = "Hello World"
            qrcodegenrator.generate()
            previews.image = "%1/Hulu/temp.png".arg(StandardPaths.writableLocation(StandardPaths.TempLocation))
        }
        onSave: {
            qrcodegenrator.save(path)
        }
    }
 
    // property GradientBackground gradientBackground: GradientBackground {
    //     colors: ["#ff0000", "#00ff00"]
    // }
    // Flow {
    //     anchors.fill: parent
    //     spacing: 10
    //     Button {
    //         id: button
    //         text: "GradientBackground"
    //         onClicked: {
                
    //             console.log("onClicked: ", qrcodegenrator.background, gradientBackground)
                
    //             qrcodegenrator.background = gradientBackground
    //         }
    //     }
    // }
}