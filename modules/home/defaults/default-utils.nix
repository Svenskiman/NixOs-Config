{ pkgs, lib, config, ... }:

{
    options = {
        myModules.defaultUtils.enable = lib.mkEnableOption "Default utils";
    };

    config = lib.mkIf config.myModules.defaultUtils.enable {
        home.packages = with pkgs; [

            # System
            wget
            git
            fastfetch
            eza
            playerctl

            # TUIs
            impala
            bluetui
            wiremix

            # Desktop
            # waybar
            hyprpaper

            # Notifications
            mako
            libnotify

            # File manager
            thunar

            adwaita-icon-theme
            adw-gtk3
        ];
    };
}