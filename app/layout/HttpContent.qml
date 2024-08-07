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

    readonly property string text: {
        if (textField.acceptableInput) {
            var inputText = textField.text.trim();
            var regex = new RegExp("^https?://", "i")
            return regex.test(inputText) ? inputText : "http://" + inputText
        }
        else
            return ""
    }

    contentItem: ColumnLayout {
        spacing: 10
        Label {
            text: "扫描二维码后将访问该网址"
            color: Themes.foreground
            Layout.alignment: Qt.AlignLeft
        }
        TextField {
            id: textField
            Layout.fillWidth: true
            validator: RegExpValidator {
                regExp: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
            }
            placeholderText: "http://"
            horizontalAlignment: TextInput.AlignLeft
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