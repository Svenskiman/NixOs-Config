import QtQuick
import qs.components
import qs.services

Panel {
    id: root

    readonly property bool isOpen: Runtime.openPanel === root.name

    // One click reveals every address, not just the row clicked
    property bool revealed: false

    // Fixed width for the centred address column
    readonly property int addressWidth: 100

    // Nudges the address column right so long device names fit
    readonly property int addressOffset: 16

    name: "tailscale"

    Binding {
        target: Tailscale
        property: "monitoring"
        value: root.isOpen
    }

    // Header
    Item {
        width: parent.width
        height: 24

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "󰖂 "
                color: Theme.colors.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Tailscale"
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }
        }

        Switch {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            checked: Tailscale.enabled
            onToggled: value => Tailscale.setEnabled(value)
        }
    }

    // Divider
    Rectangle {
        width: parent.width
        height: 1
        color: Theme.colors.color8
    }

    // Column headings
    Item {
        width: parent.width
        height: 20

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            text: "DEVICE"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: root.addressOffset
            anchors.verticalCenter: parent.verticalCenter

            width: root.addressWidth

            text: "ADDRESS"
            horizontalAlignment: Text.AlignLeft
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            text: "CONNECTED"
            horizontalAlignment: Text.AlignRight
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }
    }

    // Devices
    Repeater {
        model: Tailscale.devices

        Item {
            required property var modelData

            width: parent.width
            height: 20

            Text {
                anchors.left: parent.left
                anchors.right: address.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                text: modelData.name
                elide: Text.ElideRight
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
            }

            // Masked until clicked.
            Text {
                id: address

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: root.addressOffset
                anchors.verticalCenter: parent.verticalCenter

                width: root.addressWidth

                text: root.revealed ? modelData.address : "•".repeat(15)
                horizontalAlignment: Text.AlignLeft
                color: root.revealed ? Theme.colors.foreground : Theme.colors.color7
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.revealed = !root.revealed
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: modelData.online ? "true" : "false"
                horizontalAlignment: Text.AlignRight
                color: modelData.online ? Theme.semantic.success : Theme.colors.color8
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
            }
        }
    }
}
