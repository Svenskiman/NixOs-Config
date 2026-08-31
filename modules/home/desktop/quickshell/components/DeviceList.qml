import QtQuick
import qs.services

Column {
    id: root

    // Items to show, and which one is currently active
    required property var devices
    required property var active

    // How to get a display name out of an item
    property var labelFor: item => item.description

    // Called with the clicked item
    signal selected(var device)

    spacing: 2

    Repeater {
        model: root.devices

        Rectangle {
            id: row

            required property var modelData

            readonly property bool isActive: row.modelData === root.active

            width: root.width
            height: 30
            radius: 6

            // Active item is highlighted, hovered item slightly less so
            color: {
                if (row.isActive)
                    return Qt.alpha(Qt.color(Theme.colors.color7), 0.12);
                if (mouse.containsMouse)
                    return Qt.alpha(Qt.color(Theme.colors.color7), 0.06);
                return "transparent";
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                text: root.labelFor(row.modelData)
                elide: Text.ElideRight

                color: row.isActive ? Theme.colors.foreground : Theme.colors.color7
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
            }

            MouseArea {
                id: mouse

                anchors.fill: parent
                hoverEnabled: true

                onClicked: root.selected(row.modelData)
            }
        }
    }
}
