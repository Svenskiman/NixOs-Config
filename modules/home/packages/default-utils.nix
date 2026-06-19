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
            btop
            impala
            bluetui
            wiremix

            # Desktop
            eww
            # waybar
            hyprpaper

            # Notifications
            mako
            libnotify
            
            # Launcher
            # Walker is pulled via flake

            # File manager
            thunar


            # Wallpapers
            awww

            adwaita-icon-theme
            adw-gtk3
        ];
    };
}