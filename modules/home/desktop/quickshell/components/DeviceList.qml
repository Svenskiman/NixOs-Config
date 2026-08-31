import QtQuick
import qs.services

ListView {
    id: root

    // Items to show
    required property var devices

    // How many rows to show before scrolling
    property int maxRows: 3

    // How to get a display name out of an item
    property var labelFor: item => item.description

    // Whether an item counts as active, highlighted if so
    property var isActiveFor: item => false

    // Optional trailing status text, and its colour
    property var statusFor: item => ""
    property var statusColorFor: item => Theme.colors.color7

    // Called with the clicked item
    signal selected(var device)

    readonly property int rowHeight: 30

    model: root.devices
    spacing: 2
    clip: true

    // Grows with content up to maxRows, then scrolls
    height: Math.min(count, root.maxRows) * (root.rowHeight + spacing)

    delegate: Rectangle {
        id: row

        required property var modelData

        readonly property bool isActive: root.isActiveFor(row.modelData)

        width: root.width
        height: root.rowHeight
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
            anchors.right: status.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            text: root.labelFor(row.modelData)
            elide: Text.ElideRight

            color: row.isActive ? Theme.colors.foreground : Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
        }

        Text {
            id: status

            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            text: root.statusFor(row.modelData)

            color: root.statusColorFor(row.modelData)
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true

            onClicked: root.selected(row.modelData)
        }
    }
}
