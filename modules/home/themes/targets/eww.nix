{
  lib,
  pkgs,
  config,
  ...
}:

let
  # Generate an eww SCSS file from a theme definition.
  # Iterates over the colour attrset and emits one @define-color line per key.
  makeEwwCSS =
    theme:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "@define-color ${name} ${value};") theme.colors
    );

  # Build a home.file attrset entry for each theme.
  # Results in ~/.config/themes/<name>/eww.css per theme.
  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/eww.css";
      value = {
        text = makeEwwCSS theme;
      };
    }) config.myModules.themes.definitions
  );

  apply-theme-eww = pkgs.writeShellApplication {
    name = "apply-theme-eww";
    runtimeInputs = [
      pkgs.eww
      pkgs.procps
      pkgs.coreutils
    ];
    text = ''
      # Close windows gracefully first so GTK can tear down Wayland surfaces
      eww close-all 2>/dev/null || true
      sleep 0.3

      # Kill the daemon cleanly (SIGTERM, not SIGKILL) so it releases the compositor connection
      eww kill 2>/dev/null || true
      sleep 0.3

      pkill -KILL -f '^eww ' 2>/dev/null || true
      pkill -KILL -f 'eww-workspace-listener' 2>/dev/null || true
      sleep 0.2
      eww open bar 2>/dev/null || true
    '';
  };
in

{
  config = lib.mkIf config.myModules.eww.enable {
    xdg.configFile = themeFiles;

    myModules.themes.hooks = [
      {
        name = "apply-theme-eww";
        package = apply-theme-eww;
        priority = 90;
      }
    ];
  };
}
