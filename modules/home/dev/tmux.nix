{
  lib,
  config,
  osConfig ? { },
  ...
}:

# Tmux, plus per-host scripts from a private repo cloned to
# ~/.tmux-scripts. Only hosts/<hostname>/bin from that repo is added to PATH.
# Nothing from the private repo is read at build time.

let
  cfg = config.myModules.tmux;
  hostName = osConfig.networking.hostName or null;
in
{
  options.myModules.tmux = {
    enable = lib.mkEnableOption "tmux";

    privateScripts = {
      enable = lib.mkEnableOption "per-host scripts from the private tmux scripts repo";

      path = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.tmux-scripts";
        description = "Local clone of the private tmux scripts repo.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.tmux = {
          enable = true;
          extraConfig = ''
            # Pane title labels
            set -g pane-border-status top
            set -g pane-border-format " #{pane_title} "
          '';
        };
      }

      (lib.mkIf cfg.privateScripts.enable {
        assertions = [
          {
            assertion = hostName != null;
            message = "myModules.tmux.privateScripts needs networking.hostName from the system config.";
          }
        ];

        home.sessionPath = [ "${cfg.privateScripts.path}/hosts/${hostName}/bin" ];
      })
    ]
  );
}
