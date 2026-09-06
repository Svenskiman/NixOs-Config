import QtQuick
import qs.components
import qs.services
import qs.modules.system.components

Panel {
    id: root

    readonly property bool isOpen: Runtime.openPanel === root.name

    name: "system"

    position: "centre"
    panelWidth: 400
    panelHeight: 600

    // Polling only runs while the panel is open
    Binding {
        target: SystemStats
        property: "monitoring"
        value: root.isOpen
    }

    Header {}

    Stats {}
}
