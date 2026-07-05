{ lib, config, ... }:

{
  options.myModules.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf config.myModules.tailscale.enable {
    services.tailscale.enable = true;
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
