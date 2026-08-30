{
  lib,
  pkgs,
  config,
  ...
}:

let
  colorschemeMap = {
    gruvbox = "gruvbox";
    nord = "nord";
    everforest = "everforest";
    nocturne = "oxocarbon";
    oxocarbon = "oxocarbon";
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

  apply-theme-neovim = pkgs.writeShellApplication {
    name = "apply-theme-neovim";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      THEME_DIR=$2
      NEOVIM_FILE="$THEME_DIR/neovim.lua"

      if [ -f "$NEOVIM_FILE" ]; then
          CS=$(cat "$NEOVIM_FILE")
          nvim --headless -c "colorscheme $CS" -c "qa" 2>/dev/null || true
      fi
    '';
  };
in

{
  config = lib.mkIf config.myModules.neovim.enable {
    xdg.configFile = lib.listToAttrs (
      lib.flatten (map makeNeovimTheme config.myModules.themes.definitions)
    );

    myModules.themes.hooks = [
      {
        name = "apply-theme-neovim";
        package = apply-theme-neovim;
      }
    ];
  };
}
