{ pkgs, lib, config, ... }:

{
    options = {
        myModules.vpn.mullvad.enable = lib.mkEnableOption "Mullvad VPN";
    };

    config = lib.mkIf config.myModules.vpn.mullvad.enable {
        services.mullvad-vpn = {
            enable  = true;
            package = pkgs.mullvad-vpn;
        };

        # Required - without this Mullvad connects but DNS breaks
        services.resolved.enable = true;
    };
}