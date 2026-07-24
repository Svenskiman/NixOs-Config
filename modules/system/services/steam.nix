{ lib, config, ... }:

{
  options = {
    myModules.steam.enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf config.myModules.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };
}
