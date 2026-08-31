//@ pragma ShellId nixshell

import Quickshell
import qs.modules

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    BluetoothPanel {}
    AudioPanel {}
}
