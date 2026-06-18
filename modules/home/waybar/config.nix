{
    mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
            "group/nixmenu"
            "hyprland/workspaces"
            "group/media"
        ];

        modules-center = [
            "clock"
        ];

        modules-right = [
            "group/system-icons"
            "group/battery-tray"
        ];

        # ── Left ──────────────────────────────────────────────

        "group/nixmenu" = {
            orientation = "horizontal";
            modules = [
                "custom/nixlogo"
            ];
        };

        "custom/nixlogo" = {
            format = "󱄅 ";
            tooltip = false;
            on-click = "alacritty --class floating -e bash -c 'fastfetch; read -n1'";
        };

        "hyprland/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            all-outputs = true;
            active-only = false;
            sort-by-number = true;
            format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                active = "■";
                default = "{name}";
            };
            persistent-workspaces = {
                "1" = [];
                "2" = [];
                "3" = [];
                "4" = [];
                "5" = [];
            };
        };

        "group/media" = {
            orientation = "horizontal";
            modules = [
                "custom/title"
                "custom/prev"
                "custom/playpause"
                "custom/next"
            ];
        };

        "custom/title" = {
            exec = "waybar-title";
            interval = 1;
            signal = 8;
            tooltip = false;
        };

        "custom/prev" = {
            format = "";
            on-click = "playerctl previous";
            tooltip = false;
        };

        "custom/playpause" = {
            exec = "waybar-playpause";
            interval = 1;
            on-click = "playerctl play-pause && pkill -SIGRTMIN+8 waybar";
            tooltip = false;
            signal = 8;
        };

        "custom/next" = {
            format = "";
            on-click = "playerctl next";
            tooltip = false;
        };

        # ── Centre ────────────────────────────────────────────

        "clock" = {
            format = "{:%A %H:%M}";
            format-alt = "{:%d %B W%V %Y}";
            tooltip = false;
        };

        # ── Right ─────────────────────────────────────────────

        "group/system-icons" = {
            orientation = "horizontal";
            modules = [
                "pulseaudio"
                "bluetooth"
                "network"
                "cpu"
            ];
        };

        "pulseaudio" = {
            format = "{icon}";
            format-icons = {
                default = [ "󰕿" "󰖀" "󰕾" ];
                muted = "󰝟";
            };
            on-click = "alacritty --class floating -e wiremix";
            tooltip = false;
        };

        "bluetooth" = {
            format = "󰂯";
            format-disabled = "󰂲";
            format-off = "󰂲";
            format-connected = "󰂱";
            on-click = "alacritty --class floating -e bluetui";
            tooltip = false;
        };

        "network" = {
            format-wifi = "󰤨";
            format-disconnected = "󰤭";
            format-ethernet = "󰈀";
            on-click = "alacritty --class floating -e impala";
            tooltip = false;
        };

        "cpu" = {
            format = "";
            on-click = "alacritty --class floating -e btop";
            tooltip = false;
        };

        "group/battery-tray" = {
            orientation = "horizontal";
            click-to-reveal = true;
            drawer = {
                transition-duration = 600;
                children-class = "battery-tray-item";
                transition-left-to-right = true;
            };
            modules = [
                "group/battery-always"
                "memory"
            ];
        };

        "group/battery-always" = {
            orientation = "horizontal";
            modules = [
                "custom/battarrow"
                "battery"
            ];
        };

        "custom/battarrow" = {
            format = "❮";
            tooltip = false;
            on-scroll-up = "";
            on-scroll-down = "";
            on-scroll-left = "";
            on-scroll-right = "";
        };

        "memory" = {
            format = "  {used:0.1f}G/{total:0.1f}G";
            interval = 5;
            tooltip = false;
        };

        "battery" = {
            interval = 30;
            states = {
                warning = 49;
                critical = 20;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% {icon}";
            format-icons = ["󱊡" "󱊢" "󱊣"];
            format-charging-icons = ["󱊤" "󱊥" "󱊦"];
            tooltip = false;
        };
    };
}
