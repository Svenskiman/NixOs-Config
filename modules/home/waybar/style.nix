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
    #media,
    #clock,
    #system-icons,
    #battery-tray {
        background-color: @color0;
        color: @foreground;
        border-radius: 9999px;
        margin: 0 6px;
    }

    /* ── Nix menu pill ───────────────────────────────────── */

    #nixmenu {
        padding: 0 12px 0 16px;
    }

    #custom-nixlogo {
        color: @accent;
        font-size: 16px;
        background: transparent;
        padding: 0;
        margin: 0;
    }

    /* ── Workspaces ──────────────────────────────────────── */

    #workspaces {
        padding: 0 8px;
    }

    #workspaces button {
        all: initial;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        color: @color8;
        padding: 0 6px;
        margin: 0 1px;
        min-width: 9px;
        opacity: 0.4;
    }

    #workspaces button.active {
        color: @accent;
        opacity: 1;
    }

    #workspaces button.empty {
        opacity: 0.4;
    }

    #workspaces button:not(.empty):not(.active) {
        color: @foreground;
        opacity: 1;
    }

    #workspaces button:hover {
        color: @foreground;
        opacity: 1;
    }

    /* ── Media pill ──────────────────────────────────────── */

    #media {
        padding: 0 14px;
        min-width: 220px;
        max-width: 220px;
    }

    #custom-title,
    #custom-prev,
    #custom-playpause,
    #custom-next {
        background: transparent;
        color: @foreground;
        padding: 0 6px;
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
        color: @foreground;
        padding: 0 14px 0 8px;
        border-radius: 0;
        margin: 0;
        font-size: 15px;
    }

    #pulseaudio.muted {
        color: @color8;
    }

    #bluetooth.disabled,
    #bluetooth.off {
        color: @color8;
    }

    #network.disconnected {
        color: @color8;
    }

    /* ── RAM group ───────────────────────────────────────── */

    #battery-tray {
        padding: 0 12px 0 4px;
    }

    #custom-battarrow {
        background: transparent;
        color: @foreground;
        padding: 0 4px 0 10px;
    }

    #memory {
        background: transparent;
        color: @foreground;
        padding: 0 8px 0 14px;
    }

    #battery {
        background: transparent;
        color: @foreground;
        padding: 0 0 0 4px;
    }

    #battery { color: @color2; }
    #battery.warning { color: @color3; }
    #battery.critical { color: @color1; }
''