import QtQuick
import qs.services

Item {
    id: root

    property string leftLabel: ""
    property string leftValue: ""
    property string rightLabel: ""
    property string rightValue: ""

    // Hides both values behind a mask until clicked
    property bool maskable: false

    // Hide only one side
    property bool leftMaskable: root.maskable
    property bool rightMaskable: root.maskable

    // One click reveals both sides, rather than each independently
    property bool linked: true

    // Current reveal state, kept while the panel is closed
    property bool leftRevealed: false
    property bool rightRevealed: false

    // Gap between the two halves
    property int columnSpacing: 12

    // Smallest gap allowed between a label and its value
    property int labelGap: 8

    property int fontSize: 12

    readonly property bool leftMasked: root.leftMaskable && !root.leftRevealed
    readonly property bool rightMasked: root.rightMaskable && !root.rightRevealed

    readonly property real columnWidth: (width - columnSpacing) / 2

    implicitHeight: 20

    // Same character count as the real value, so the layout doesn't shift
    function display(value, masked) {
        return masked ? "•".repeat(value.length) : value;
    }

    // Clicking either side moves both when linked
    function toggle(side) {
        if (root.linked) {
            const value = side === "left" ? !root.leftRevealed : !root.rightRevealed;
            root.leftRevealed = value;
            root.rightRevealed = value;
            return;
        }

        if (side === "left")
            root.leftRevealed = !root.leftRevealed;
        else
            root.rightRevealed = !root.rightRevealed;
    }

    // Left half
    Item {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: root.columnWidth

        Text {
            id: leftLabelText

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            text: root.leftLabel
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.fontSize
        }

        Text {
            id: leftValueText

            anchors.left: leftLabelText.right
            anchors.leftMargin: root.labelGap
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            text: root.display(root.leftValue, root.leftMasked)
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight

            color: root.leftMasked ? Theme.colors.color7 : Theme.colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.fontSize
        }

        MouseArea {
            anchors.fill: leftValueText
            enabled: root.leftMaskable
            cursorShape: Qt.PointingHandCursor

            onClicked: root.toggle("left")
        }
    }

    // Right half
    Item {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: root.columnWidth

        Text {
            id: rightLabelText

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            text: root.rightLabel
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.fontSize
        }

        Text {
            id: rightValueText

            anchors.left: rightLabelText.right
            anchors.leftMargin: root.labelGap
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            text: root.display(root.rightValue, root.rightMasked)
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight

            color: root.rightMasked ? Theme.colors.color7 : Theme.colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.fontSize
        }

        MouseArea {
            anchors.fill: rightValueText
            enabled: root.rightMaskable
            cursorShape: Qt.PointingHandCursor

            onClicked: root.toggle("right")
        }
    }
}
