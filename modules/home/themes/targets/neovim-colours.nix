{ lib, config, ... }:

let
  colorschemeMap = {
    gruvbox = "gruvbox";
    nord = "nord";
    everforest = "everforest";
    nocturne = "oxocarbon";
  };

  makeNeovimTheme =
    theme:
    let
      cs = colorschemeMap.${theme.name} or null;
    in
    lib.optional (cs != null) {
      name = "themes/${theme.name}/neovim.lua";
      value.text = cs;
    };
in

{
  config = lib.mkIf config.myModules.neovim.enable {
    xdg.configFile = lib.listToAttrs (
      lib.flatten (map makeNeovimTheme config.myModules.themes.definitions)
    );
  };
}
