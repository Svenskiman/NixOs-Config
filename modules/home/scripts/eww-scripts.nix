{ pkgs, lib, config, ... }:

let
    # Streams live Hyprland workspace state to eww via deflisten.
    #
    # Emits one JSON line per update, shaped as:
    #   {"active": <id>, "occupied": [<id>, <id>, ...]}
    #
    # "active"   - the currently focused workspace ID
    # "occupied" - every workspace ID that currently has at least one window
    eww-workspace-listener = pkgs.writeShellApplication {
        name = "eww-workspace-listener";
        runtimeInputs = [ pkgs.socat pkgs.hyprland pkgs.jq ];
        text = ''
            # Hyprland's event socket - emits plain-text lines like
            # "workspace>>3" any time something relevant happens.
            SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

            # Queries current Hyprland state directly (via hyprctl) and
            # prints it as a single JSON line.
            emit_state() {
                active=$(hyprctl activeworkspace -j | jq -c '.id')
                occupied=$(hyprctl workspaces -j | jq -c '[.[] | select(.windows > 0) | .id]')
                jq -nc --argjson active "$active" --argjson occupied "$occupied" \
                    '{active: $active, occupied: $occupied}'
            }

            # Emit once immediately on startup
            emit_state

            # Then keep listening forever, re-emitting state whenever a
            # workspace-relevant event comes through the socket.
            socat -U - "UNIX-CONNECT:$SOCKET" | while read -r line; do
                case "$line" in
                    workspace\>\>*|createworkspace\>\>*|destroyworkspace\>\>*|openwindow\>\>*|closewindow\>\>*|movewindow\>\>*)
                        emit_state
                        ;;
                esac
            done
        '';
    };


    # Polls the default audio sink's volume/mute state via wpctl.
    # Emits one JSON line: {"volume": <0-100>, "muted": true|false}
    eww-audio-status = pkgs.writeShellApplication {
        name = "eww-audio-status";
        runtimeInputs = [ pkgs.wireplumber pkgs.jq ];
        text = ''
            status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
            raw=$(echo "$status" | awk '{print $2}')
            volume=$(awk -v v="$raw" 'BEGIN { printf "%d", v * 100 }')

            if echo "$status" | grep -q MUTED; then
                muted=true
            else
                muted=false
            fi

            jq -nc --argjson volume "$volume" --argjson muted "$muted" \
                '{volume: $volume, muted: $muted}'
        '';
    };

    # Polls Bluetooth power/connection state via bluetoothctl.
    # Emits one JSON line: {"powered": true|false, "connected": true|false}
    eww-bluetooth-status = pkgs.writeShellApplication {
        name = "eww-bluetooth-status";
        runtimeInputs = [ pkgs.bluez pkgs.jq pkgs.gnugrep ];
        text = ''
            if bluetoothctl show | grep -q "Powered: yes"; then
                powered=true
            else
                powered=false
            fi

            if bluetoothctl info | grep -q "Connected: yes"; then
                connected=true
            else
                connected=false
            fi

            jq -nc --argjson powered "$powered" --argjson connected "$connected" \
                '{powered: $powered, connected: $connected}'
        '';
    };
in

{
    options = {
        myModules.scripts.eww.enable = lib.mkEnableOption "Eww scripts";
    };

    config = lib.mkIf config.myModules.scripts.eww.enable {
        home.packages = [
            eww-workspace-listener
            eww-audio-status
            eww-bluetooth-status
        ];
    };
}