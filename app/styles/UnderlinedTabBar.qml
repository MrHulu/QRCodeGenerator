import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    id: control

    required property var tabTexts // 标签内容
    property int currentIndex: 0 // 当前选中的标签索引
    property color textColor: "black" // 文字颜色
    property color activeTextColor: "#FF66B8FF" // 选中时的文字颜色
    property color underlineColor: "#FF66B8FF" // 下划线颜色
    property int underlineHeight: 2 // 下划线高度
    property bool autofill: true // 是否自动填充

    signal tabChanged(int index)

    implicitHeight: 40
    implicitWidth: 300

    onCurrentIndexChanged: tabChanged(currentIndex)

    onTabTextsChanged: {
        if(tabs.isComplete)
            rowLayout.updateTabWidth()
    }

    Row {
        id: rowLayout
        anchors.fill: parent
        spacing: autofill ? (control.width - (tabTexts.length * tabWidth)) / (tabTexts.length - 1) : tabWidth / 10

        property int tabWidth: 0
        function updateTabWidth() {
            for(var i = 0; i < tabTexts.length; i++)
                rowLayout.tabWidth = Math.max(rowLayout.tabWidth , tabs.itemAt(i).width)
        }

        Repeater {
            id: tabs
            model: tabTexts
            readonly property bool isComplete: count === tabTexts.length
            Component.onCompleted: rowLayout.updateTabWidth() 

            Rectangle {
                width: tabText.width + 20
                height: control.height
                color: "transparent"
                property alias tabText: tabText

                Text {
                    id: tabText
                    anchors.centerIn: parent
                    text: modelData
                    color: index === currentIndex ? activeTextColor : textColor
                    font.pixelSize: control.height / 3
                    // font.bold: true
                    width: implicitWidth
                }

                // 下划线
                Rectangle {
                    width: tabText.width
                    height: underlineHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: tabText.bottom
                    anchors.topMargin:  underlineHeight * 2
                    color: underlineColor
                    visible: index === currentIndex
                    radius: underlineHeight / 2
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: currentIndex = index
                }
            }
        }
    }
}