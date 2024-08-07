import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.15
import QtQuick.Window 2.12
import "../styles"

Popup {
    id: popup
    visible: false
    implicitWidth: 400
    implicitHeight: 280

    leftPadding: 32
    rightPadding: 32
    topPadding: 18
    bottomPadding: 18
    
    
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

    readonly property alias color: colorPreview.color
    readonly property alias text: colorText.text
    property bool alphaEnabled: true
    signal accepted(color color, string rgba)

    function show(parentItem) {
        if (parentItem) {
            parent = parentItem
            var mappedPoint = parent.mapToItem(ApplicationWindow.window.contentItem, 0, 0)
            y = (mappedPoint.y + parent.height + height > ApplicationWindow.window.height) ?  - height : parent.height 
            x = (mappedPoint.x + width > ApplicationWindow.window.width) ? - width : 0
        }
        popup.open()
    } 

    contentItem: Item {
        GridLayout {
            anchors.fill: parent
            rowSpacing: 6
            columnSpacing: 20

            ColumnLayout {
                Layout.row: 1; Layout.rowSpan: 3; Layout.column: 0
                Layout.fillWidth: true; Layout.fillHeight: true
                spacing: 8

                SquareColorPalette {
                    id: colorPalette
                    Layout.fillWidth: true
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 160                
                    radius: 4
                    hsvHue: hueSlider.hsvHue
                }
                HsvHueSlider {
                    id: hueSlider
                    Layout.fillWidth: true
                    value: colorPalette.hsvHue
                    onPressedChanged: {
                        if (!pressed) {
                            value = Qt.binding(()=>colorPalette.hsvHue)
                        }
                    }
                    onMoved: colorPalette.hsvHue = hsvHue
                }
                AlphaSlider {
                    id: alphaSlider
                    visible: alphaEnabled
                    Layout.fillWidth: true
                    color: colorPalette.getColor()
                    // onPressedChanged: {
                    //     if (!pressed) {
                    //         value = Qt.binding(()=>colorPalette.hsvValue)
                    //     }
                    // }
                    // onMoved: colorPalette.hsvValue = value
                }
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    Rectangle { // color preview
                        id: colorPreview
                        anchors.left: parent.left
                        width: parent.height
                        height: parent.height
                        color: colorText.temp_color
                        radius: 4
                        border.color: "#20ffffff"
                        border.width: 1
                    }
                    TextField { // color text
                        id: colorText
                        anchors.left: colorPreview.right
                        anchors.leftMargin: 8
                        width: 75
                        validator: RegExpValidator { 
                            regExp: popup.alphaEnabled ? /^#([a-fA-F0-9]){8,8}$/ : /^#([a-fA-F0-9]){6,6}$/
                        }
                        horizontalAlignment: TextInput.AlignLeft
                        color: "white"
                        function toRGB(color) {
                            var colorComponentToHex = function(c) {
                                var hex = c.toString(16);
                                return hex.length == 1 ? "0" + hex : hex;
                            };
                            return "#" + colorComponentToHex(Math.round(color.r * 255)) +
                                        colorComponentToHex(Math.round(color.g * 255)) +
                                        colorComponentToHex(Math.round(color.b * 255));
                        }
                        function toARGB(color) {
                            var colorComponentToHex = function(c) {
                                var hex = c.toString(16);
                                return hex.length == 1 ? "0" + hex : hex;
                            };
                            return "#" + colorComponentToHex(Math.round(color.a * 255)) +
                                        colorComponentToHex(Math.round(color.r * 255)) +
                                        colorComponentToHex(Math.round(color.g * 255)) +
                                        colorComponentToHex(Math.round(color.b * 255));
                        }
                        property color temp_color: acceptableInput ? text : "red"
                        function setColor() {
                            if (acceptableInput) {
                                colorPalette.setColor(temp_color)
                                alphaSlider.value = temp_color.a
                            }
                            text = Qt.binding(
                                ()=>popup.alphaEnabled 
                                    ? toARGB( Qt.rgba(colorPalette.getColor().r, colorPalette.getColor().g, colorPalette.getColor().b, alphaSlider.value) )
                                    : toRGB(colorPalette.getColor())
                            )
                        }
                        text: popup.alphaEnabled 
                            ? toARGB(Qt.rgba(colorPalette.getColor().r, colorPalette.getColor().g, colorPalette.getColor().b, alphaSlider.value))
                            : toRGB(colorPalette.getColor())
                        onAccepted: setColor()
                        onActiveFocusChanged: { if (!activeFocus) { setColor() } }
                    }
                    TextField { // alpha text
                        id: alphaText
                        visible: alphaEnabled
                        anchors.right: parent.right
                        width: 50
                        validator: IntValidator { bottom: 0; top: 100 }
                        color: "white"
                        function setAlpha() {
                            if (acceptableInput) alphaSlider.value = text / 100 
                            text = Qt.binding(()=>Math.ceil(alphaSlider.value * 100))
                        }
                        text: Math.ceil(alphaSlider.value * 100)
                        onAccepted: setAlpha()
                        onActiveFocusChanged: { if (!activeFocus) { setAlpha() } }

                    }

                }
            }
            
            Label { // 默认颜色
                Layout.row: 1; Layout.column: 1
                text: "颜色预览"
                color: "white"
                Layout.preferredWidth: 150
            }

            Item { // 默认颜色
                Layout.row: 2; Layout.column: 1
                Layout.preferredWidth: 150
                Layout.fillWidth: true; Layout.fillHeight: true

                Flow {
                    anchors.fill: parent
                    anchors.bottomMargin: 60
                    spacing: 6
                    Repeater {
                        model: [
                            "#FFFF0000","#FFFF6400","#FFFFA800","#FF00FF00","#FF56F7FC","#FF0000FF","#FFB04CF7",
                            "#FFF856CE","#FFFF5555","#FFFE9E73","#FFFFF685","#FF5DFF70","#FF99FDFF","#FF5F97FF",
                            "#FFCB82FF","#FFFF89E0","#FF7F170E","#FFC16B10","#FFC4B500","#FF458933","#FF40C0C4",
                            "#FF104CBC","#FF742FA6","#FFA13284","#FFFFFFFF","#FF000000","#FF504347","#FF8A8A8A",
                            "#FFC8C8C8","#FFDADADA"]
                        Rectangle {
                            width: 24
                            height: width
                            radius: width / 2
                            color: modelData
                            border.color: "#20ffffff"
                            border.width: 1
                            TapHandler {
                                onTapped: {
                                    colorPalette.setColor(color)
                                    alphaSlider.value = color.a
                                }
                            }
                            layer.enabled: false
                        }
                    }
                }
            } 

            RowLayout {
                Layout.row: 3; Layout.column: 1
                Layout.fillWidth: true
                spacing: 8
                Item { Layout.fillWidth: true }
                GradientButton {
                    Layout.preferredWidth: 54
                    Layout.preferredHeight: 24
                    text: qsTranslate("", "取消")
                    layer.enabled: false
                    buttonColor: "#FFDADADA"
                    buttonColor2: "#FFFFFFFF"
                    textColor: "#FF000000"
                    onReleased:  popup.close() 
                }
                GradientButton {
                    Layout.preferredWidth: 54
                    Layout.preferredHeight: 24
                    text: qsTranslate("", "确定")
                    useStyle: GradientButton.Style.ButtonLineGradient
                    layer.enabled: false
                    buttonColor: "#FF8A8A8A"
                    buttonColor2: "#FFC8C8C8"
                    textColor: "#FFFFFFFF"
                    onReleased: {
                        popup.accepted(popup.color, popup.text)
                        popup.close()
                    }
                }
            }  
        } // GridLayout
    }

    background: Item {
        Rectangle {
            id: background
            anchors.fill: parent
            color: "#404347"
            radius: 16
        }
        DropShadow {
            anchors.fill: parent
            source: background
            radius: 28
            samples: 20
            color: "#24565759"
        }
    }
}