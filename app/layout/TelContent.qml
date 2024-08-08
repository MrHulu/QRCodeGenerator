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

    readonly property string text: textField.acceptableInput ? "tel:" + textField.text : ""

    contentItem: ColumnLayout {
        spacing: 10
        Label {
            text: "手机扫描二维码后将准备拨打该号码"
            color: Themes.foreground
            Layout.alignment: Qt.AlignLeft
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(comboBox.implicitHeight, textField.implicitHeight)
            Label {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                text: "国家/地区"
                color: Themes.foreground
            }
            ComboBox {
                id: comboBox
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label.right
                width: 200
                anchors.leftMargin: 10
                model: ["--", "China(+86)", "United States(+1)"]
                backgroundColor: Themes.secondaryColor
                currentIndex: 0
            }
        }
        TextField {
            id: textField
            Layout.fillWidth: true
            validator: RegExpValidator {
                regExp: {
                    switch(comboBox.currentIndex) {
                        case 1:
                            return /^(\+?86)?1[3-9]\d{9}$|^(0\d{2,3}-?|\(0\d{2,3}\))?[1-9]\d{6,7}$/
                        case 2:
                            return /^(\+1|1)?[-.\s]?\(?[2-9]\d{2}\)?[-.\s]?\d{3}[-.\s]?\d{4}$/
                        default:
                            return /^(\+|00)?[1-9]\d{0,2}[-.\s]?(\(\d{1,4}\)|\d{1,4})[-.\s]?\d{1,12}$/
                    }
                }
            }
            placeholderText: "输入电话号码"
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