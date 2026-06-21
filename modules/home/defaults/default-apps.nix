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
            sublime4

            # Media
            mpv
            blanket

            obsidian

            # Disabled
            # foliate # E-reader
            # gnome-solanum # Timer
        ];
    };
}