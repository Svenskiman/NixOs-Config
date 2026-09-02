{
  lib,
  config,
  ...
}:

{
  options = {
    myModules.networking.enable = lib.mkEnableOption "Enables internet";

    myModules.networking.backend = lib.mkOption {
      type = lib.types.enum [
        "networkd"
        "networkmanager"
      ];
      default = "networkd";
      description = "Which stack manages network interfaces on this host";
    };
  };

  config = lib.mkIf config.myModules.networking.enable (
    lib.mkMerge [

      (lib.mkIf (config.myModules.networking.backend == "networkd") {
        networking.useNetworkd = true;
        networking.wireless.iwd.enable = true;

        systemd.network.wait-online.enable = false;

        # Handle all ethernet interfaces via DHCP automatically
        systemd.network.networks."10-ethernet" = {
          matchConfig.Name = "en*";
          networkConfig.DHCP = "ipv4";
          linkConfig.RequiredForOnline = "no";
        };
      })

      (lib.mkIf (config.myModules.networking.backend == "networkmanager") {
        networking.networkmanager.enable = true;

        # Hand DNS to resolved rather than letting NM write resolv.conf
        networking.networkmanager.dns = "systemd-resolved";
        services.resolved.enable = true;

        systemd.services.NetworkManager-wait-online.enable = false;

        users.users.svenski.extraGroups = [ "networkmanager" ];
      })
    ]
  );
}
