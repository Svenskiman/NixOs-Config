{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./../../modules/system/default.nix
        ./../../modules/system/services/display-manager.nix
    ];

    networking.hostName = "beelzebub";

    # Enable if not using SDDM
    # services.getty.autologinUser = "svenski";

    # System modules
    myModules.boot.enable = true;
    myModules.plymouth.enable = true;

    myModules.networking.enable = true;
    myModules.vpn.mullvad.enable = true;
    myModules.docker.enable = true;
    myModules.audio.enable = true;
    myModules.bluetooth.enable = true;
    myModules.displayManager.sddm.enable = true;
    myModules.fonts.enable = true;
    myModules.hyprlock.enable = true;

    programs.zsh.enable = true;
    programs.dconf.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Install Hyprland
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
    };

    # Scaling
    environment.sessionVariables.QT_SCALE_FACTOR = "2";

    # VFS Daemon
    services.gvfs.enable = true;

    # Do NOT change this value
    system.stateVersion = "26.05";
}