{
  lib,
  pkgs,
  config,
  ...
}:

let
  makeMakoConfig = theme: ''
    default-timeout=2000
    background-color=${theme.colors.background}
    text-color=${theme.colors.foreground}
    border-color=${theme.colors.accent}
    progress-color=over ${theme.colors.accent}

    [urgency=low]
    background-color=${theme.colors.background}
    border-color=${theme.semantic.muted}

    [urgency=normal]
    background-color=${theme.colors.background}
    border-color=${theme.colors.accent}

    [urgency=critical]
    background-color=${theme.colors.background}
    border-color=${theme.semantic.error}
  '';

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/mako.ini";
      value = {
        text = makeMakoConfig theme;
      };
    }) config.myModules.themes.definitions
  );

  apply-theme-mako = pkgs.writeShellApplication {
    name = "apply-theme-mako";
    runtimeInputs = [
      pkgs.mako
      pkgs.coreutils
    ];
    text = ''
      THEME_DIR=$2

      mkdir -p "$HOME/.config/mako"
      cp "$THEME_DIR/mako.ini" "$HOME/.config/mako/config"
      # As created file is read only
      chmod 644 "$HOME/.config/mako/config"
      makoctl reload
    '';
  };
in

{
  config = {
    xdg.configFile = themeFiles;

    myModules.themes.hooks = [
      {
        name = "apply-theme-mako";
        package = apply-theme-mako;
      }
    ];
  };
}
