import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../styles"

Control {
    id: control
    implicitWidth: 300
    implicitHeight: 400
    padding: 10
    clip: false

    required property bool isReady
    required property url image
    
    signal previews()
    signal save(url path)
    
    ColumnLayout {
        id: row
        spacing: 20
        anchors.fill: parent
        anchors.margins: 20
        
        Control {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Image {
                visible: !isReady
                opacity: control.enabled ? 1 : 0.5
                anchors.centerIn: parent
                width: parent.width/4
                height: parent.height/4
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/icons/setting.svg"
                RotationAnimation on rotation {
                    running: true
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 3000
                }
            }
            Image {
                id: preview
                visible: isReady
                anchors.fill: parent       
                cache: false         
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                source: visible ? image : "" // 刷新
            }
        }
        RowLayout {
            width: control.width - row.spacing
            spacing: 20
            GradientButton {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                enabled: isReady
                radius: height/3
                text: "保存"       
                useStyle: GradientButton.Style.ButtonLineGradient
                onClicked: fileDialog.open()
            }
            GradientButton {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                radius: height/3
                text: "预览"
                onClicked: control.previews()
            }
        }
    }
    FileDialog {
        id: fileDialog
        title: "保存"
        folder: shortcuts.pictures
        selectExisting: false
        nameFilters: ["Images (*.png)"]
        onAccepted: {
            control.save(fileDialog.fileUrl)
        }
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