//@ pragma ShellId nixshell

import Quickshell
import qs.modules.bar
import qs.modules.bar.panels
import qs.modules.system
import qs.modules

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Tailscale {}
    Wifi {}
    Bluetooth {}
    Audio {}

    System {}

    Ipc {}
}
