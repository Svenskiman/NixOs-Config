{ lib, config, ... }:

let
  # Generate Walker's CSS colour variables from a theme definition.
  makeWalkerCSS = theme: ''
    @define-color window_bg_color ${theme.colors.background};
    @define-color accent_bg_color ${theme.colors.accent};
    @define-color theme_fg_color  ${theme.colors.foreground};
    @define-color error_bg_color  ${theme.colors.color1};
    @define-color error_fg_color  ${theme.colors.foreground};
  '';

  # Build an xdg.configFile entry for each theme.
  # Results in ~/.config/themes/<name>/walker.css per theme.
  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/walker.css";
      value = {
        text = makeWalkerCSS theme;
      };
    }) config.myModules.themes.definitions
  );
in

{
  config = lib.mkIf config.myModules.walker.enable {
    xdg.configFile = themeFiles;
  };
}
