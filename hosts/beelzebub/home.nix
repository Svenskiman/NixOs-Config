{ pkgs, config, ... }:

{
    imports = [
        ./../../modules/home/default.nix
    ];

    # Core
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

    # Monitors
    myModules.hypr.monitors = [
        {
            output = "eDP-1";
            mode = "preferred";
            position = "auto";
            scale = 2.0;
        }
    ];


    # Applications (configured)
    myModules.discord.enable = true;
    myModules.alacritty.enable = true;
    myModules.btop.enable = true;
    myModules.keepassxc.enable = true;
    myModules.imv.enable = true;
    myModules.evince.enable = true;
    myModules.onlyoffice.enable = true;

    # Config
    myModules.isLaptop = true;
    myModules.xdg.enable = true;
    myModules.zsh.enable = true;

    # Defaults (not configured)
    myModules.defaultApps.enable = true;
    myModules.defaultUtils.enable = true;

    # Desktop environment
    myModules.hypr.enable = true;
    myModules.eww.enable = true;
    myModules.waybar.enable = false;
    myModules.walker.enable = true;
    myModules.nautilus.enable = true;

    # Dev environment
    myModules.direnv.enable = true;

    # Patches
    myModules.audioFixes.zenbookMicBoost.enable = true;

    # Scripts
    myModules.scripts.screenshot.enable = true;

    # Services
    myModules.swayosd.enable = true;
    myModules.wallpaper.enable = true;
    myModules.dropbox.enable = true;
    myModules.hyprlock.enable = true;
    myModules.hypridle.enable = true;

    # Clamshell
    myModules.clamshell.enable = false;

    # Uncomment if not using SDDM
    # programs.bash = {
    #     enable = true;
    #     profileExtra = ''
    #         if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    #             exec start-hyprland
    #         fi
    #     '';
    # };
}