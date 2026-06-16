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

            # TUIs
            btop
            impala
            bluetui
            wiremix

            # Desktop
            waybar
            hyprpaper

            # Notifications
            mako
            libnotify
            
            # Launcher
            walker
            elephant

            # File manager
            nautilus

            adwaita-icon-theme
        ];
    };
}