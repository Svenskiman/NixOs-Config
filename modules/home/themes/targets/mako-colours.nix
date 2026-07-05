{ lib, config, ... }:

let
  makeMakoConfig = theme: ''
    default-timeout=2000
    background-color=${theme.colors.background}
    text-color=${theme.colors.foreground}
    border-color=${theme.colors.accent}
    progress-color=over ${theme.colors.accent}

    [urgency=low]
    background-color=${theme.colors.background}
    border-color=${theme.colors.color8}

    [urgency=normal]
    background-color=${theme.colors.background}
    border-color=${theme.colors.accent}

    [urgency=critical]
    background-color=${theme.colors.background}
    border-color=${theme.colors.color1}
  '';

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/mako.ini";
      value = {
        text = makeMakoConfig theme;
      };
    }) config.myModules.themes.definitions
  );
in

{
  config = {
    xdg.configFile = themeFiles;
  };
}
