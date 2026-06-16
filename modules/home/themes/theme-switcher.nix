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
        source "$THEME_DIR/hyprland-colours.sh"
        hyprctl keyword general:col.active_border "$ACTIVE_BORDER"
        hyprctl keyword general:col.inactive_border "$INACTIVE_BORDER"

        echo "Theme set to $THEME"
    '';
in

{   
    # Add to $PATH
    config = {
        home.packages = [ nix-theme-set ];
    };
}