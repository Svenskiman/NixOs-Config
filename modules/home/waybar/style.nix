''
    * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
    }

    window#waybar {
        background: transparent;
    }

    /* ── Pill base ───────────────────────────────────────── */

    #nixmenu,
    #workspaces,
    #clock,
    #system-icons,
    #battery-tray {
        background-color: @pill_bg;
        color: @fg;
        border-radius: 9999px;
        margin: 0 6px;
    }

    /* ── Nix menu pill ───────────────────────────────────── */

    #nixmenu {
        padding: 0 4px 0 12px;
    }

    #custom-nixlogo {
        color: @accent;
        font-size: 16px;
        background: transparent;
        padding: 0;
        margin: 0;
    }

    #custom-nixarrow {
        color: @fg;
        background: transparent;
        padding: 0 10px 0 4px;
        margin: 0;
        font-size: 11px;
    }

    /* ── Workspaces ──────────────────────────────────────── */

    #workspaces {
        padding: 0 8px;
    }

    #workspaces button {
        all: initial;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        color: @ws_empty;
        padding: 0 6px;
        margin: 0 1px;
        min-width: 9px;
        opacity: 0.4;
    }

    #workspaces button.active {
        color: @ws_active;
        opacity: 1;
    }

    #workspaces button.empty {
        opacity: 0.4;
    }

    #workspaces button:not(.empty):not(.active) {
        color: @ws_occupied;
        opacity: 1;
    }

    #workspaces button:hover {
        color: @fg;
        opacity: 1;
    }

    /* ── Clock ───────────────────────────────────────────── */

    #clock {
        font-weight: 500;
        padding: 0 14px;
    }

    /* ── System icons group ──────────────────────────────── */

    #system-icons {
        padding: 0 6px;
    }

    #pulseaudio,
    #bluetooth,
    #network,
    #cpu {
        background: transparent;
        color: @fg;
        padding: 0 8px;
        border-radius: 0;
        margin: 0;
        font-size: 15px;
    }

    #pulseaudio.muted {
        color: @muted;
    }

    #bluetooth.disabled,
    #bluetooth.off {
        color: @muted;
    }

    #network.disconnected {
        color: @muted;
    }

    /* ── RAM group ───────────────────────────────────────── */

    #battery-tray {
        padding: 0 12px 0 4px;
    }

    #custom-battarrow {
        background: transparent;
        color: @fg;
        padding: 0 4px 0 10px;
    }

    #memory {
        background: transparent;
        color: @fg;
        padding: 0 8px 0 14px;
    }

    #battery {
        background: transparent;
        color: @fg;
        padding: 0 0 0 4px;
    }

    #battery { color: @battery_good; }
    #battery.warning { color: @battery_warning; }
    #battery.critical { color: @battery_critical; }
''
