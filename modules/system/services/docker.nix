{ lib, config, ... }:

{
  options = {
    myModules.docker.enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf config.myModules.docker.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    virtualisation.oci-containers.backend = "docker";
  };
}
