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
    myModules.tailscale.enable = true;
    myModules.docker.enable = true;
    myModules.secrets.enable = true;

    services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
        };
    };

    sops.defaultSopsFile = ./secrets.yaml;
    sops.secrets = builtins.listToAttrs (map (name: {
        inherit name;
        value.owner = "shrike";
    }) [
        "minecraft_friends_rcon_password"
        "valheim_server_password"
    ]);

    # Docker servers
    myModules.servers.games.minecraft.enable = true;
    myModules.servers.games.valheim.enable = true;

    programs.zsh.enable = true;

    time.timeZone = "Europe/London";

    system.stateVersion = "26.05";
}