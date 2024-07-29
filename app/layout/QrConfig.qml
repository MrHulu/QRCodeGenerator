import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../styles"
import "../components"

Item {
    id: control
    implicitWidth: 400
    implicitHeight: 300

    UnderlinedTabBar {
        id: tabBar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        autofill: false
        tabTexts: ["颜色", "样式", "其他"]
        onTabChanged: swipeView.currentIndex = index 
    }
    Control {
        anchors.left: parent.left
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        SwipeView {
            id: swipeView
            anchors.fill: parent
            anchors.margins: 32
            interactive: false
            clip: true
            onCurrentIndexChanged: tabBar.currentIndex = currentIndex
            
            Rectangle {
                visible: swipeView.currentIndex === 0
                color: "transparent"
                ColumnLayout {
                    anchors.fill: parent
                    // width: parent.width
                    spacing: 10
                    QrForegroundConfig {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1;color: "#40404347" }
                }
            }

            Rectangle {
                visible: swipeView.currentIndex === 1
                color: "green"
                opacity: 0.5
                CircleRing {
                    anchors.centerIn: parent
                    ringColor: "red"
                    innerRadius: 40
                    outerRadius: 60
                }
            }
            Rectangle {
                visible: swipeView.currentIndex === 2
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
}