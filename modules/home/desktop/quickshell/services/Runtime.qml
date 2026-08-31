pragma Singleton

import Quickshell

Singleton {
    id: root

    // Name of the currently open panel, empty when none
    property string openPanel: ""

    function toggle(name) {
        root.openPanel = root.openPanel === name ? "" : name;
    }
}
