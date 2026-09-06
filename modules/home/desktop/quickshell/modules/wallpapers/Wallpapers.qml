import Quickshell
import QtQuick
import qs.services
import qs.modules.wallpapers.components

PanelWindow {
    id: root

    readonly property bool isOpen: Runtime.openPanel === "wallpapers"

    // Tweak these to taste
    readonly property int slideWidth: 120
    readonly property int selectedWidth: 380
    readonly property int slideHeight: 440

    // Horizontal lean, applied to the whole row so slides stay flush
    readonly property real lean: 0.1

    // Must be odd so there's a true middle slot
    readonly property int slotCount: 11
    readonly property int centreSlot: Math.floor(root.slotCount / 2)

    // Which image sits in the middle slot
    property int currentIndex: 0

    // Animated back to 0 after each step, which reads as sliding
    property real slideOffset: 0

    readonly property int count: Wallpaper.images.length

    // "1-misty-forest.png" becomes "Misty Forest"
    readonly property string currentName: {
        if (root.count === 0)
            return "";

        const file = Wallpaper.images[root.currentIndex].split("/").pop();
        const bare = file.replace(/\.[^.]+$/, "").replace(/^\d+-/, "");

        return bare.split("-").map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(" ");
    }

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

        Wallpaper.refresh();
        keys.forceActiveFocus();
    }

    // isOpen never changes when the panel starts open, so kick it off here too
    Component.onCompleted: if (root.isOpen) {
        Wallpaper.refresh();
        keys.forceActiveFocus();
    }

    // Start on whatever wallpaper is currently set
    Connections {
        target: Wallpaper

        function onImagesChanged() {
            root.currentIndex = Wallpaper.currentIndex;
        }
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
            Wallpaper.apply(Wallpaper.images[root.currentIndex]);
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

                Slide {
                    required property int index

                    readonly property bool isCentre: index === root.centreSlot

                    // Wraps in both directions, so the ends meet
                    readonly property int imageIndex: root.count === 0 ? 0 : (root.currentIndex + index - root.centreSlot + root.count * 100) % root.count

                    width: isCentre ? root.selectedWidth : root.slideWidth
                    height: root.slideHeight

                    path: root.count === 0 ? "" : Wallpaper.images[imageIndex]
                    selected: isCentre
                }
            }
        }

        // Name of the selected wallpaper
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

            visible: root.currentName !== ""

            Text {
                id: label

                anchors.centerIn: parent

                text: root.currentName
                color: Theme.colors.foreground
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
            }
        }
    }
}
