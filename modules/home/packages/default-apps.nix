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

            # Media
            mpv
            blanket # Sounds

            # Disabled
            # foliate # E-reader
            # gnome-solanum # Timer

            # Installed via flake
            # spotify
            # spicetify-cli

        ];
    };
}