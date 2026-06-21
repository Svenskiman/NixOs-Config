{ pkgs, lib, config, ... }:

let
    hyprland-monitor-internal = pkgs.writeShellApplication {
        name = "hyprland-monitor-internal";
        runtimeInputs = [ pkgs.hyprland pkgs.jq ];
        text = ''
            # Called by lid-switch binds. Usage: hyprland-monitor-internal <on|off>

            # Detect internal panel name dynamically (e.g. eDP-1) rather than hardcoding it
            INTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP")) | .name' | head -n 1)

            case "''${1:-}" in
                off)
                    EXTERNAL_COUNT=$(hyprctl monitors -j | jq --arg internal "$INTERNAL" \
                        '[.[] | select(.name != $internal)] | length')
                    if [ "$EXTERNAL_COUNT" -gt 0 ]; then
                        hyprctl eval "hl.monitor({ output = '$INTERNAL', disabled = true })"
                    fi
                    ;;
                on)
                    hyprctl eval "hl.monitor({ output = '$INTERNAL', mode = 'preferred', position = 'auto', scale = 'auto' })"
                    ;;
            esac
        '';
    };
in

{
    options = {
        myModules.clamshell.enable = lib.mkEnableOption "Laptop clamshell mode";
    };

    config = lib.mkIf config.myModules.clamshell.enable {
        home.packages = [ hyprland-monitor-internal ];
    };
}