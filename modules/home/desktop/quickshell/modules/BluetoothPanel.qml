import Quickshell
import QtQuick
import qs.components
import qs.services

Panel {
    id: root

    name: "bluetooth"

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
                text: "󰂯 "
                color: Theme.colors.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Bluetooth"
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
            }
        }

        // Opens bluetui for pairing new devices
        Rectangle {
            id: scan

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            implicitWidth: scanLabel.implicitWidth + 20
            implicitHeight: 24

            radius: 6

            color: scanMouse.containsMouse ? Qt.alpha(Qt.color(Theme.colors.color7), 0.12) : "transparent"

            border.width: 1
            border.color: scanMouse.containsMouse ? Theme.colors.accent : Theme.colors.color8

            Text {
                id: scanLabel

                anchors.centerIn: parent

                text: "scan"

                color: scanMouse.containsMouse ? Theme.colors.foreground : Theme.colors.color7
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
            }

            MouseArea {
                id: scanMouse

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    Quickshell.execDetached(["alacritty", "--class", "floating", "-e", "bluetui"]);
                    Runtime.openPanel = "";
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.colors.color8
    }

    // Paired devices
    Item {
        width: parent.width
        height: 18

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: "PAIRED"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 10
            text: "CONNECTED"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }
    }

    DeviceList {
        width: parent.width
        devices: Bluetooth.paired
        labelFor: device => device.name
        isActiveFor: device => device.connected

        statusFor: device => Bluetooth.stateText(device)

        statusColorFor: device => {
            if (Bluetooth.isBusy(device))
                return Theme.semantic.warning;
            return device.connected ? Theme.semantic.success : Theme.semantic.error;
        }

        onSelected: device => Bluetooth.toggleDevice(device)
    }
}
