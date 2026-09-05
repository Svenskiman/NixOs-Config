//@ pragma ShellId nixshell

import Quickshell
import qs.modules.bar
import qs.modules.bar.panels

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Wifi {}
    Bluetooth {}
    Audio {}
}