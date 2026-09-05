import QtQuick
import qs.components
import qs.services

Column {
    id: root

    readonly property var rows: [
        {
            glyph: "󰍛",
            label: "CPU",
            percent: SystemStats.cpu,
            available: true
        },
        {
            glyph: "󱕎",
            label: "GPU",
            percent: SystemStats.gpu,
            available: SystemStats.gpuAvailable
        },
        {
            glyph: "󰙬",
            label: "VRAM",
            percent: SystemStats.vram,
            available: SystemStats.gpuAvailable
        },
        {
            glyph: "",
            label: "RAM",
            percent: SystemStats.ram,
            available: true
        }
    ]

    width: parent.width
    spacing: 6

    Repeater {
        model: root.rows

        Rectangle {
            id: pill

            required property var modelData

            width: root.width
            implicitHeight: 34

            radius: height / 2
            color: Qt.alpha(Qt.color(Theme.colors.color7), 0.08)

            Text {
                id: icon

                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.verticalCenter: parent.verticalCenter

                text: pill.modelData.glyph
                color: Theme.colors.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 15
            }

            Text {
                id: label

                anchors.left: icon.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                width: 40

                text: pill.modelData.label
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
            }

            ProgressBar {
                anchors.left: label.right
                anchors.leftMargin: 10
                anchors.right: value.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                value: pill.modelData.percent / 100
                available: pill.modelData.available
            }

            Text {
                id: value

                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter

                width: 34

                text: pill.modelData.available ? pill.modelData.percent + "%" : "n/a"
                horizontalAlignment: Text.AlignRight
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
            }
        }
    }
}
