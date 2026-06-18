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
            glib
            gtk3

            # TUIs
            btop
            impala
            bluetui
            wiremix

            # Desktop
            waybar
            hyprpaper
            gsettings-desktop-schemas

            # Notifications
            mako
            libnotify
            
            # Launcher
            # Walker is pulled via flake

            # File manager
            nautilus

            # Wallpapers
            awww

            adwaita-icon-theme
            papirus-icon-theme
            papirus-folders 
        ];
    };
}