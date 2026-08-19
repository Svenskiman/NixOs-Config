{
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.nix;
in
{
  options.myModules.nix.enable = lib.mkEnableOption "Darwin Nix settings";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
