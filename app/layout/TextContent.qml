import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.15
import "../styles"

Control {
    id: control
    implicitHeight: 300
    implicitWidth: 400
    padding: 20

    readonly property string text: textField.length > control.maxLength ? textField.text.substring(0, control.maxLength) : textField.text
    property int maxLength: 2000

    contentItem: ColumnLayout {
        spacing: 10
        Label {
            text: "扫描二维码后将显示该内容"
            color: Themes.foreground
            Layout.alignment: Qt.AlignLeft
        }
        TextArea {
            id: textField
            Layout.fillWidth: true
            Layout.fillHeight: true
            // validator: RegExpValidator { regExp: /^[\s\S]{0,control.maxLength}$/ }
            placeholderText: "输入文本内容"
            background: Rectangle {
                radius: 10
                color: Themes.background
                border.color: {
                    if (textField.length <= control.maxLength)
                        if(control.activeFocus || control.hovered)
                            return Themes.accent
                        else
                            return Themes.foreground
                    else
                        return "red"
                }
                border.width: 1
            }
        }
        Label {
            id: lengthLabel
            Layout.alignment: Qt.AlignRight
            text: textField.text.length + "/" + control.maxLength
            color: Themes.foreground
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