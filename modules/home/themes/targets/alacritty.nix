{
  lib,
  pkgs,
  config,
  ...
}:

let
  makeAlacrittyTOML = theme: ''
    [colors.primary]
    background = "${theme.colors.background}"
    foreground = "${theme.colors.foreground}"

    [colors.cursor]
    text   = "${theme.colors.background}"
    cursor = "${theme.colors.cursor}"

    [colors.vi_mode_cursor]
    text   = "${theme.colors.background}"
    cursor = "${theme.colors.cursor}"

    [colors.search.matches]
    foreground = "${theme.colors.background}"
    background = "${theme.colors.color3}"

    [colors.search.focused_match]
    foreground = "${theme.colors.background}"
    background = "${theme.colors.color1}"

    [colors.footer_bar]
    foreground = "${theme.colors.background}"
    background = "${theme.colors.foreground}"

    [colors.selection]
    text       = "${theme.colors.selection_foreground}"
    background = "${theme.colors.selection_background}"

    [colors.normal]
    black   = "${theme.colors.color0}"
    red     = "${theme.colors.color1}"
    green   = "${theme.colors.color2}"
    yellow  = "${theme.colors.color3}"
    blue    = "${theme.colors.color4}"
    magenta = "${theme.colors.color5}"
    cyan    = "${theme.colors.color6}"
    white   = "${theme.colors.color7}"

    [colors.bright]
    black   = "${theme.colors.color8}"
    red     = "${theme.colors.color9}"
    green   = "${theme.colors.color10}"
    yellow  = "${theme.colors.color11}"
    blue    = "${theme.colors.color12}"
    magenta = "${theme.colors.color13}"
    cyan    = "${theme.colors.color14}"
    white   = "${theme.colors.color15}"
  '';

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/alacritty.toml";
      value = {
        text = makeAlacrittyTOML theme;
      };
    }) config.myModules.themes.definitions
  );

  apply-theme-alacritty = pkgs.writeShellApplication {
    name = "apply-theme-alacritty";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      THEME_DIR=$2

      mkdir -p "$HOME/.config/alacritty"
      chmod 644 "$HOME/.config/alacritty/colors.toml" 2>/dev/null || true
      cp "$THEME_DIR/alacritty.toml" "$HOME/.config/alacritty/colors.toml"
      chmod 644 "$HOME/.config/alacritty/colors.toml"
    '';
  };
in

{
  config = lib.mkIf config.myModules.alacritty.enable {
    xdg.configFile = themeFiles;

    myModules.themes.hooks = [
      {
        name = "apply-theme-alacritty";
        package = apply-theme-alacritty;
      }
    ];
  };
}
