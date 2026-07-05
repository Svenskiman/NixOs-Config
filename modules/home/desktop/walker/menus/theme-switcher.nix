{ lib, config, ... }:

let
  # Generate a TOML menu entry for each theme definition.
  # Selecting a theme runs nix-theme-set <name>.
  makeThemeEntry = theme: ''
    [[entries]]
    text    = "${theme.displayName}"
    actions = { activate = "nix-theme-set ${theme.name}" }
  '';

  menuContent = ''
    name        = "themes"
    name_pretty = "Themes"

  ''
  + lib.concatStringsSep "\n" (map makeThemeEntry config.myModules.themes.definitions);
in

{
  config = lib.mkIf config.myModules.walker.enable {
    xdg.configFile."elephant/menus/themes.toml".text = menuContent;
  };
}
