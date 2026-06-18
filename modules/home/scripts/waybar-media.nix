{ pkgs, lib, config, ... }:

let
    waybar-title = pkgs.writeShellApplication {
        name = "waybar-title";
        runtimeInputs = [ pkgs.playerctl ];
        text = ''
            title=$(playerctl metadata title 2>/dev/null)
            if [ -z "$title" ]; then
                echo "Nothing playing"
            else
                echo "$title"
            fi
        '';
    };

    waybar-playpause = pkgs.writeShellApplication {
        name = "waybar-playpause";
        runtimeInputs = [ pkgs.playerctl ];
        text = ''
            status=$(playerctl status 2>/dev/null)
            if [ "$status" = "Playing" ]; then
                echo "󰏤"
            else
                echo "󰐊"
            fi
        '';
    };
in

{
    options = {
        myModules.scripts.waybarMedia.enable = lib.mkEnableOption "Waybar media scripts";
    };

    config = lib.mkIf config.myModules.scripts.waybarMedia.enable {
        home.packages = [
            waybar-title
            waybar-playpause
        ];
    };
}