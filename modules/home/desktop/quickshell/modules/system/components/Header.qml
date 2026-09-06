import QtQuick
import Quickshell
import qs.services

Item {
    id: root

    // Falls back to behemoth.png when there's no image for this host
    property bool imageFailed: false

    // Poweroff, logout, lock, reboot
    readonly property var actions: [
        {
            glyph: "",
            colour: Theme.colors.color1,
            command: ["systemctl", "poweroff"]
        },
        {
            glyph: "󰍃",
            colour: Theme.colors.color3,
            command: ["loginctl", "terminate-session", Quickshell.env("XDG_SESSION_ID")]
        },
        {
            glyph: "",
            colour: Theme.colors.color4,
            command: ["loginctl", "lock-session"]
        },
        {
            glyph: "",
            colour: Theme.colors.color5,
            command: ["systemctl", "reboot"]
        }
    ]

    width: parent.width
    height: 120

    Image {
        id: hostImage

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        width: 120
        height: 120

        // Waits for the hostname before trying
        source: SystemStats.hostname === "" ? "" : (root.imageFailed ? "root:/assets/behemoth.png" : `root:/assets/${SystemStats.hostname}.png`)

        onStatusChanged: if (status === Image.Error && !root.imageFailed)
            root.imageFailed = true
    }

    Column {
        anchors.left: hostImage.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        spacing: 6

        Text {
            text: SystemStats.hostname.toUpperCase()
            color: Theme.colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            text: SystemStats.uptime
            color: Qt.alpha(Qt.color(Theme.colors.foreground), 0.6)
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
        }

        // Power pill
        Rectangle {
            implicitWidth: powerRow.implicitWidth + 24
            implicitHeight: 34

            radius: height / 2
            color: Qt.alpha(Qt.color(Theme.colors.color7), 0.08)

            Row {
                id: powerRow

                anchors.centerIn: parent
                spacing: 6

                Repeater {
                    model: root.actions

                    Rectangle {
                        id: button

                        required property var modelData

                        implicitWidth: 38
                        implicitHeight: 26

                        radius: height / 2

                        color: mouse.containsMouse ? Qt.alpha(button.modelData.colour, 0.25) : "transparent"

                        Text {
                            anchors.centerIn: parent

                            text: button.modelData.glyph
                            color: button.modelData.colour
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }

                        MouseArea {
                            id: mouse

                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                Runtime.openPanel = "";
                                Quickshell.execDetached(button.modelData.command);
                            }
                        }
                    }
                }
            }
        }
    }
}
