import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import "../styles"

Control {
    id: control
    implicitWidth: 300
    implicitHeight: 80
    
    signal qrCodeTypeChanged(string type)
    readonly property int currentIndex: flow.currentIndex
    

    Flow {
        id: flow
        anchors.margins: 20
        anchors.fill: parent
        spacing: 20
        property int currentIndex: 0
        Repeater {
            model: [
                {
                    text: "文本",
                    icon: "qrc:/resources/icons/text.svg",
                    index: 0
                },
                {
                    text: "链接",
                    icon: "qrc:/resources/icons/http.svg",
                    index: 1
                },
                {
                    text: "邮件",
                    icon: "qrc:/resources/icons/email.svg",
                    index: 2
                },
                {
                    text: "电话",
                    icon: "qrc:/resources/icons/tel.svg",
                    index: 3
                },
                {
                    text: "WiFi",
                    icon: "qrc:/resources/icons/wifi.svg",
                    index: 4
                }
            ]
            delegate: Button {
                width: 80
                height: 35
                text: "%1".arg(modelData.text)
                icon.source: modelData.icon
                icon.width: 24
                icon.height: 24
                highlighted: flow.currentIndex === index
                icon.color: highlighted ? Themes.background : Themes.accent
                autoExclusive: true
                Material.foreground: highlighted ? Themes.background : Themes.accent
                onClicked: {
                    if(highlighted) return
                    flow.currentIndex = index    
                    control.qrCodeTypeChanged(modelData.text)
                } 
                background: Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: highlighted ? Themes.accent : "transparent"
                }
            }
        }
    }
    background: Rectangle {
        anchors.fill: parent
        color: "whitesmoke"
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 10
            samples: 16
            color: "grey"
        }
    }
}