{ lib, config, pkgs, ... }:

let
    themeNames = map (t: t.name) config.myModules.themes.definitions;

    nix-theme-set = pkgs.writeShellScriptBin "nix-theme-set" ''
        THEME=$1

        # Validate theme name
        if [ -z "$THEME" ]; then
            echo "Usage: nix-theme-set <theme-name>"
            exit 1
        fi

        THEME_DIR="$HOME/.config/themes/$THEME"

        if [ ! -d "$THEME_DIR" ]; then
            echo "Theme '$THEME' not found in $THEME_DIR"
            exit 1
        fi

        # Update the active theme symlink atomically
        ln -sfn "$THEME_DIR" "$HOME/.local/state/theme/current"
        echo "$THEME" > "$HOME/.local/state/theme/active-theme"


        # ── Waybar ────────────────────────────────────────────
        # SIGUSR2 triggers a CSS reload without restarting
        pkill -SIGUSR2 waybar


        # ── Hyprland ──────────────────────────────────────────
        hyprctl reload > /dev/null 2>&1


        # ── Mako ──────────────────────────────────────────────
        mkdir -p "$HOME/.config/mako"
        cp "$THEME_DIR/mako.ini" "$HOME/.config/mako/config"
        # As created file is read only
        chmod 644 "$HOME/.config/mako/config"
        makoctl reload

        # ── Walker ────────────────────────────────────────────
        pkill walker

        echo "Theme set to $THEME"
    '';
in

{   
    # Add to $PATH
    config = {
        home.packages = [ nix-theme-set ];
    };
}