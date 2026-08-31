{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

let
  # Name of the config directory under ~/.config/quickshell.
  # Launch with: qs -c nixshell
  configName = "nixshell";

  # Path to the QML sources inside the repo checkout.
  # Symlinked out of the nix store so edits hot-reload without a rebuild.
  qmlSource = "${config.home.homeDirectory}/.config/nixconf/modules/home/desktop/quickshell";
in

{
  options = {
    myModules.quickshell.enable = lib.mkEnableOption "Quickshell";
  };

  config = lib.mkIf config.myModules.quickshell.enable {

    home.packages = [
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."quickshell/${configName}".source = config.lib.file.mkOutOfStoreSymlink qmlSource;
  };
}
