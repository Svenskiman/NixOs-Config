{
  lib,
  config,
  pkgs,
  ...
}:

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

    # Sometimes 'dropbox status' cant find daemons socket
    home.activation.dropboxSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "$HOME/.dropbox" ]; then
          $DRY_RUN_CMD ln -s "$HOME/.dropbox-hm/.dropbox" "$HOME/.dropbox"
      fi
    '';

    home.packages = [ dropbox-open ];
  };
}
