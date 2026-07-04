{ pkgs, lib, config, ... }:

{
    options = {
        myModules.networking.enable = lib.mkEnableOption "Enables internet";
    };

    config = lib.mkIf config.myModules.networking.enable {
        networking.useNetworkd = true;
        networking.wireless.iwd.enable = true;

        # Handle all ethernet interfaces via DHCP automatically
        systemd.network.networks."10-ethernet" = {
            matchConfig.Name = "en*";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "no";
        };
    };
}