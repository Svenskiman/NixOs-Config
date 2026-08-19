{
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.homebrew;
in
{
  options.myModules.homebrew = {
    enable = lib.mkEnableOption "Homebrew package management";

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of Homebrew formulae to install";
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of Homebrew casks to install";
    };

    taps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of Homebrew taps to add";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };
      taps = cfg.taps;
      brews = cfg.brews;
      casks = cfg.casks;
    };
  };
}
