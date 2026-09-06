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

  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Foreground run for iterating on QML, with logs in the terminal.
  # Kills the background instance first, hands it back on exit.
  qs-dev = pkgs.writeShellApplication {
    name = "qs-dev";
    runtimeInputs = [ quickshell ];
    text = ''
      qs kill -c ${configName} || true
      trap 'qs -c ${configName} -n -d' EXIT
      qs -c ${configName} "$@"
    '';
  };
in

{
  options = {
    myModules.quickshell.enable = lib.mkEnableOption "Quickshell";
  };

  config = lib.mkIf config.myModules.quickshell.enable {

    home.packages = [
      quickshell
      pkgs.rocmPackages.rocm-smi
      qs-dev
    ];

    xdg.configFile."quickshell/${configName}".source = config.lib.file.mkOutOfStoreSymlink qmlSource;
  };
}
