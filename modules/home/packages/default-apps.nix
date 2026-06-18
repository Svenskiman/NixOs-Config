{ pkgs, lib, config, ... }:

{
    options = {
        myModules.defaultApps.enable = lib.mkEnableOption "Default apps";
    };

    config = lib.mkIf config.myModules.defaultApps.enable {
        home.packages = with pkgs; [

            # Terminals
            alacritty
            kitty

            # Browsers
            brave

            # Editors
            vim
            vscode
            zed-editor

            # Tools
            mpv
            blanket # Sounds

            spotify-player

            # Disabled
            # foliate # E-reader
            # gnome-solanum # Timer

        ];
    };
}