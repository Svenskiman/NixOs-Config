{ pkgs, lib, config, ... }:

{
    options = {
        myModules.networking.enable = lib.mkEnableOption "Enables internet";
    };

    config = lib.mkIf config.myModules.networking.enable {
        networking.networkmanager.enable = false;

        # Use iwd as the WiFi backend for NetworkManager (required for Impala TUI)
        networking.wireless.iwd.enable = true;
    };
}