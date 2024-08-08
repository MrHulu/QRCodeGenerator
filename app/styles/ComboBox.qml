import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    font.pixelSize: 14
    font.weight: Font.Medium
    
    
    property color backgroundColor: "#FFF5F7FA"
    property color color: "#FF000000"
    property int radius: 4

    topPadding: 8
    bottomPadding: 8
    leftPadding: 20 + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: 20 + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    spacing: 0

    delegate: MenuItem {
        width: ListView.view.width - leftInset - rightInset
        height: 38
        topInset: 2
        bottomInset: 2
        leftInset: 4
        rightInset: 4
        leftPadding: 22
        font: control.font
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        Material.foreground: control.currentIndex === index ? "#FF338BFF" : "#A6404347"
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: IsoscelesTriangle {
        id: dropIndicator
        size: 6
        color: control.color
        opacity: 0.6
        radius: 2
        NumberAnimation on rotation { 
            duration: 150
            running: !control.popup.visible
            from: 0; to: 180
            easing.type: Easing.InOutQuad
        }
        rotation: control.popup.visible ? 0 : 180
        x: control.mirrored ? width / 2 : control.width - width - width / 2 
        y: control.topPadding + (control.availableHeight - height) / 2
    }
    
    contentItem: T.TextField {
        leftPadding: control.mirrored ? 0 : 4
        rightPadding: control.mirrored ? 4 : 0

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse

        font: control.font
        color: control.color
        selectionColor: control.Material.accentColor
        selectedTextColor: control.Material.primaryHighlightedTextColor
        verticalAlignment: Text.AlignVCenter


        cursorDelegate: CursorDelegate { }
    }
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 32
        // anchors.fill: parent
        radius: 4
        color: control.backgroundColor
    }

    popup: T.Popup {
        y: control.height + 12
        implicitWidth: contentItem.implicitWidth
        width: Math.max(control.width, implicitWidth)
        height: Math.min(contentItem.implicitHeight + topPadding + bottomPadding,
                         control.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: 12
        bottomMargin: 12
        padding: 2

        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        contentItem: ScrollView {
            implicitHeight: contentHeight
            implicitWidth: contentWidth
            rightPadding: 2
            leftPadding: 2
            ScrollBar.vertical.policy: listView.interactive ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ListView {
                id: listView
                anchors.fill: parent
                anchors.rightMargin: parent.ScrollBar.vertical.policy === ScrollBar.AlwaysOn ? parent.width - parent.ScrollBar.vertical.x : 0
                clip: true
                model: control.delegateModel
                currentIndex: control.highlightedIndex
                highlightMoveDuration: 0
                interactive: height < topMargin + contentHeight || visibleArea.yPosition !== 0
            }
        }

        background: Rectangle {
            radius: control.radius
            color: control.backgroundColor
        }
    }
}
