import Quickshell
import QtQuick
import qs.components
import qs.services

Panel {
    id: root

    readonly property bool isOpen: Runtime.openPanel === root.name

    name: "wifi"

    // Scanning and polling only run while the panel is open
    Binding {
        target: Network
        property: "scanning"
        value: root.isOpen
    }

    Binding {
        target: Network
        property: "monitoring"
        value: root.isOpen
    }

    // Wifi header
    Item {
        width: parent.width
        height: 24

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "󰤨 "
                color: Theme.colors.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Network.ssid
                color: Network.active ? Theme.semantic.success : Theme.semantic.error
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }
        }

        Switch {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            checked: Network.enabled
            onToggled: value => Network.setEnabled(value)
        }
    }

    // Ethernet status, hidden on machines with no wired port
    Item {
        width: parent.width
        height: 24

        visible: Network.wiredDevice !== null

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "󰈀 "
                color: Theme.colors.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Ethernet"
                color: Network.ethernetConnected ? Theme.semantic.success : Theme.semantic.error
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            text: Network.ethernetConnected ? "connected" : "disconnected"
            color: Network.ethernetConnected ? Theme.semantic.success : Theme.semantic.error
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
        }
    }

    // Divider
    Rectangle {
        width: parent.width
        height: 1
        color: Theme.colors.color8
    }

    // Connection stats
    StatRow {
        width: parent.width

        leftLabel: "Ping"
        leftValue: Network.active && Network.ping >= 0 ? Math.round(Network.ping) + " ms" : "—"

        rightLabel: "Signal"
        rightValue: Network.active ? Math.round(Network.strength * 100) + "%" : "—"
    }

    StatRow {
        width: parent.width

        leftLabel: "Receiving"
        leftValue: Network.formatRate(Network.rxRate)

        rightLabel: "Sending"
        rightValue: Network.formatRate(Network.txRate)
    }

    StatRow {
        width: parent.width

        leftLabel: "Downloaded"
        leftValue: Network.formatTotal(Network.rxTotal)

        rightLabel: "Uploaded"
        rightValue: Network.formatTotal(Network.txTotal)
    }

    StatRow {
        width: parent.width

        maskable: true

        leftLabel: "IP Address"
        leftValue: Network.ipAddress !== "" ? Network.ipAddress : "—"

        rightLabel: "Gateway"
        rightValue: Network.gateway !== "" ? Network.gateway : "—"
    }

    // Divider
    Rectangle {
        width: parent.width
        height: 1
        color: Theme.colors.color8
    }

    // Known networks
    Item {
        width: parent.width
        height: 18

        Text {
            anchors.left: parent.left
            text: "KNOWN NETWORKS"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }

        Text {
            anchors.right: parent.right
            text: "CONNECTED"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }
    }

    DeviceList {
        width: parent.width
        maxRows: 3

        devices: Network.known
        labelFor: network => network.name
        isActiveFor: network => network.connected

        statusFor: network => Network.stateText(network)
        statusColorFor: network => network.connected ? Theme.semantic.success : Theme.semantic.error

        onSelected: network => Network.toggleNetwork(network)
    }

    // Other networks
    Item {
        width: parent.width
        height: 18

        Text {
            anchors.left: parent.left
            text: "OTHER NETWORKS"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }

        Text {
            anchors.right: parent.right
            text: "SIGNAL"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }
    }

    DeviceList {
        width: parent.width
        maxRows: 4

        devices: Network.unknown
        labelFor: network => network.name
        isActiveFor: network => false

        statusFor: network => Network.signalText(network)
        statusColorFor: network => Theme.colors.color7
    }
}
