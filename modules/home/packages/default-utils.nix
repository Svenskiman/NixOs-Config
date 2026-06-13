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

            # Desktop
            waybar
            hyprpaper
            networkmanagerapplet

            # Notifications
            mako
            libnotify
            
            # Launcher
            walker
            elephant
        ];
    };
}