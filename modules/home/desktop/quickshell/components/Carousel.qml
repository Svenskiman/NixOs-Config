import Quickshell
import QtQuick
import qs.services

PanelWindow {
    id: root

    // Panel name, matched against Runtime.openPanel
    required property string name

    // [{ image, label, value }]
    required property var items

    // Index to open on
    required property int startIndex

    // Emitted when the user presses Enter
    signal accepted(var value)

    readonly property bool isOpen: Runtime.openPanel === root.name

    property int slideWidth: 120
    property int selectedWidth: 380
    property int slideHeight: 440

    // Horizontal lean, applied to the whole row so slides stay flush
    property real lean: 0.1

    // Must be odd so there's a true middle slot
    readonly property int slotCount: 11
    readonly property int centreSlot: Math.floor(root.slotCount / 2)

    // Which item sits in the middle slot
    property int currentIndex: 0

    // Animated back to 0 after each step, which reads as sliding
    property real slideOffset: 0

    readonly property int count: root.items.length

    // Guards the item itself rather than `count`, which can lag a cycle
    // behind `items` and leave the index pointing past the end of the list
    readonly property string currentLabel: root.items?.[root.currentIndex]?.label ?? ""

    // The list changes underneath us when the theme switches, so an index
    // left over from the previous set has to be pulled back into range
    onItemsChanged: if (root.currentIndex >= root.count)
        root.currentIndex = 0

    function step(direction) {
        if (root.count === 0)
            return;

        root.currentIndex = (root.currentIndex + direction + root.count) % root.count;

        // Start displaced in the direction travelled, then settle
        slideAnimation.from = direction * root.slideWidth;
        slideAnimation.restart();
    }

    visible: root.isOpen

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    color: Qt.alpha(Qt.color(Theme.colors.background), 0.85)

    exclusionMode: ExclusionMode.Ignore

    // Takes keyboard from whatever's underneath while open
    focusable: true

    onIsOpenChanged: {
        if (!root.isOpen)
            return;

        root.currentIndex = root.startIndex;
        keys.forceActiveFocus();
    }

    NumberAnimation {
        id: slideAnimation

        target: root
        property: "slideOffset"
        to: 0
        duration: 160
        easing.type: Easing.OutCubic
    }

    Item {
        id: keys

        anchors.fill: parent

        focus: true

        Keys.onLeftPressed: root.step(-1)
        Keys.onRightPressed: root.step(1)

        Keys.onReturnPressed: {
            if (root.count > 0)
                root.accepted(root.items[root.currentIndex].value);

            Runtime.openPanel = "";
        }

        Keys.onEscapePressed: Runtime.openPanel = ""

        // Fixed slots. The row never moves; the images rotate through it.
        Row {
            id: strip

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: root.slideOffset

            spacing: 0

            // Sheared as one piece, so the slides always sit flush
            transform: Matrix4x4 {
                matrix: Qt.matrix4x4(1, -root.lean, 0, root.lean * strip.height / 2, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
            }

            Repeater {
                model: root.slotCount

                CarouselSlide {
                    required property int index

                    readonly property bool isCentre: index === root.centreSlot

                    // Wraps in both directions, so the ends meet
                    readonly property int itemIndex: root.count === 0 ? 0 : (root.currentIndex + index - root.centreSlot + root.count * 100) % root.count

                    width: isCentre ? root.selectedWidth : root.slideWidth
                    height: root.slideHeight

                    // Same guard as currentLabel: a stale `count` can produce
                    // an index that looks valid but isn't
                    path: root.items?.[itemIndex]?.image ?? ""
                    selected: isCentre
                }
            }
        }

        // Label for the selected item
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: strip.bottom
            anchors.topMargin: 24

            implicitWidth: label.implicitWidth + 32
            implicitHeight: 36

            radius: 8
            color: Theme.colors.background
            border.width: 1
            border.color: Theme.colors.color8

            visible: root.currentLabel !== ""

            Text {
                id: label

                anchors.centerIn: parent

                text: root.currentLabel
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
            }
        }
    }
}
