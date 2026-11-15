{ lib, config, pkgs, ... }:

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
    programs.gamemode.enable = true;
    environment.systemPackages = [ pkgs.mangohud ];
  };
}
