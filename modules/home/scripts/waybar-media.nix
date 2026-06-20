{ pkgs, lib, config, ... }:

let
    waybar-title = pkgs.writeShellApplication {
        name = "waybar-title";
        runtimeInputs = [ pkgs.playerctl ];
        text = ''
            title=$(playerctl --player=spotify_player metadata title 2>/dev/null)
            if [ -z "$title" ]; then
                echo "Nothing playing"
            else
                if [ "''${#title}" -gt 15 ]; then
                    echo "''${title:0:15}..."
                else
                    echo "$title"
                fi
            fi
        '';
    };

    waybar-playpause = pkgs.writeShellApplication {
        name = "waybar-playpause";
        runtimeInputs = [ pkgs.playerctl ];
        text = ''
            status=$(playerctl --player=spotify_player status 2>/dev/null)
            if [ "$status" = "Playing" ]; then
                echo "󰏤"
            else
                echo "󰐊"
            fi
        '';
    };
in

{
    config = lib.mkIf config.myModules.waybar.enable {
        home.packages = [
            waybar-title
            waybar-playpause
        ];
    };
}