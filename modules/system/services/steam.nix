{ lib, config, ... }:

{
  options = {
    myModules.steam.enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf config.myModules.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = true;
    };
  };
}
