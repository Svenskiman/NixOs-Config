{ lib, config, pkgs, ... }:

{
    options = {
        myModules.waybar.enable = lib.mkEnableOption "Waybar";
    };

    config = lib.mkIf config.myModules.waybar.enable {
        programs.waybar = {
            enable = true;
            package = pkgs.waybar;
            settings = import ./config.nix;
            style = (import ./style.nix) + (import ./themes/nord.nix);
        };
    };
}
