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
            lazydocker

            # Desktop
            hyprpaper
            gnome-calculator

            # Notifications
            mako
            libnotify

            adw-gtk3
            adwaita-icon-theme
        ];
    };
}