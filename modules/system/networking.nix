{ pkgs, lib, config, ... }:

# Kind of pointless as its just a wrapper for the networking module?
{
    options = {
        myModules.networking.enable = lib.mkEnableOption "Enables internet";
    };

    # Configure network connections interactively with nmcli or nmtui.
    config = lib.mkIf config.myModules.networking.enable {
        networking.networkmanager.enable = true;
    };
}