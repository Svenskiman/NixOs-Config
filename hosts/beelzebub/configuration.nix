{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./../../modules/system/default.nix
    ];

    networking.hostName = "beelzebub";
    # services.getty.autologinUser = "svenski";

    # System modules
    myModules.networking.enable = true;
    myModules.audio.enable = true;
    myModules.bluetooth.enable = true;
    myModules.displayManager.sddm.enable = true;
    myModules.fonts.enable = true;

    programs.zsh.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Install Hyprland
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
    };

    # VFS Daemon
    services.gvfs.enable = true;

    # Do NOT change this value
    system.stateVersion = "26.05";
}