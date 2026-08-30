{
  lib,
  pkgs,
  config,
  ...
}:

let
  ordered = lib.sort (a: b: a.priority < b.priority) config.myModules.themes.hooks;

  nix-theme-set = pkgs.writeShellScriptBin "nix-theme-set" ''
    THEME=$1

    if [ -z "$THEME" ]; then
        echo "Usage: nix-theme-set <theme-name>"
        exit 1
    fi

    THEME_DIR="$HOME/.config/themes/$THEME"

    if [ ! -d "$THEME_DIR" ]; then
        echo "Theme '$THEME' not found in $THEME_DIR"
        exit 1
    fi

    mkdir -p "$HOME/.local/state/theme"
    ln -sfn "$THEME_DIR" "$HOME/.local/state/theme/current"
    echo "$THEME" > "$HOME/.local/state/theme/active-theme"

    ${lib.concatMapStringsSep "\n" (h: ''
      ${h.package}/bin/${h.name} "$THEME" "$THEME_DIR" || true
    '') ordered}

    echo "Theme set to $THEME"
  '';
in

{
  options = {
    myModules.themes.hooks = lib.mkOption {
      default = [ ];
      description = "Scripts run by nix-theme-set. Each receives $1 = theme name, $2 = theme dir.";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Binary name inside the package.";
            };
            priority = lib.mkOption {
              type = lib.types.int;
              default = 50;
              description = "Lower runs first.";
            };
            package = lib.mkOption { type = lib.types.package; };
          };
        }
      );
    };
  };

  config = {
    home.packages = [ nix-theme-set ];
  };
}
