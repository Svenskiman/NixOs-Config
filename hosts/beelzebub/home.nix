{ pkgs, config, ... }:

{
    imports = [
        ./../../modules/home/default.nix
    ];

    # Defaults
    myModules.defaultApps.enable = true;
    myModules.defaultUtils.enable = true;

    # Terminal
    myModules.zsh.enable = true;
    myModules.alacritty.enable = true;
    myModules.btop.enable = true;

    # Scripts
    myModules.scripts.screenshot.enable = true;

    # Desktop
    myModules.hypr.enable = true;
    myModules.eww.enable = true;
    myModules.waybar.enable = false;
    myModules.walker.enable = true;
    myModules.wallpaper.enable = true;

    # User dirs
    myModules.xdg.enable = true;

    # Media
    myModules.spicetify.enable = true;
    myModules.dropbox.enable = true;

    home.username = "svenski";
    home.homeDirectory = "/home/svenski";
    home.stateVersion = "26.05";

    home.sessionVariables = {
        GTK_THEME = "adw-gtk3-dark";
    };

    gtk = {
        enable = true;
        theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
        };
    };

    programs.bash = {
        enable = true;
        profileExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                exec start-hyprland
            fi
        '';
    };
}