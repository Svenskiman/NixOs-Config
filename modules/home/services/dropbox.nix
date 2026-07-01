{ lib, config, pkgs, ... }:

# TODO: This is ass and needs adjusting
# Should make a enum.nix or something defining applications like in bindings.nix
let
    dropbox-open = pkgs.writeShellApplication {
        name = "dropbox-open";
        runtimeInputs = [ pkgs.nautilus ];
        text = ''
            nautilus "$HOME/.dropbox-hm/Dropbox/"
        '';
    };
in

{
    options.myModules.dropbox.enable = lib.mkEnableOption "Dropbox sync";

    config = lib.mkIf config.myModules.dropbox.enable {
        services.dropbox.enable = true;

        home.packages = [ dropbox-open ];
    };
}