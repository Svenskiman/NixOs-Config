{ pkgs, lib, config, ... }:

{
    options = {
        myModules.defaultApps.enable = lib.mkEnableOption "Default apps";
    };

    config = lib.mkIf config.myModules.defaultApps.enable {
        home.packages = with pkgs; [

            # Terminals
            kitty # Hyprland's default 

            # Browsers
            brave

            # Editors
            vim
            vscode

            # Media
            mpv
            blanket

            # Disabled
            # foliate # E-reader
            # gnome-solanum # Timer
        ];
    };
}