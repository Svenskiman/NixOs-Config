{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./../../modules/system/default.nix
    ];

    networking.hostName = "hyperion";

    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.efi.canTouchEfiVariables = false;

    myModules.networking.enable = true;
    myModules.docker.enable = true;

    services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
        };
    };

    programs.zsh.enable = true;

    time.timeZone = "Europe/London";

    system.stateVersion = "26.05";
}