{ pkgs, lib, config, ... }:

let
    # ── Programs ────────────────────────────────────────
    # Logic for applying theme to a specific program
    # Create a new one for each 'themable' program

    apply-theme-eww = pkgs.writeShellApplication {
        name = "apply-theme-eww";
        text = ''
            eww reload 2>/dev/null || true
        '';
    };

    apply-theme-wallpaper = pkgs.writeShellApplication {
        name = "apply-theme-wallpaper";
        runtimeInputs = [ pkgs.findutils pkgs.coreutils ];
        text = ''
            THEME=$1

            WALLPAPER_DIR="$HOME/.config/nixconf/assets/wallpapers/$THEME"
            FIRST_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" \) | sort | head -1)

            if [ -n "$FIRST_WALLPAPER" ]; then
                awww img "$FIRST_WALLPAPER" --transition-type fade
            fi
        '';
    };

    apply-theme-hyprland = pkgs.writeShellApplication {
        name = "apply-theme-hyprland";
        runtimeInputs = [ pkgs.hyprland ];
        text = ''
            hyprctl reload > /dev/null 2>&1
        '';
    };

    apply-theme-mako = pkgs.writeShellApplication {
        name = "apply-theme-mako";
        runtimeInputs = [ pkgs.mako pkgs.coreutils ];
        text = ''
            THEME_DIR=$1

            mkdir -p "$HOME/.config/mako"
            cp "$THEME_DIR/mako.ini" "$HOME/.config/mako/config"
            # As created file is read only
            chmod 644 "$HOME/.config/mako/config"
            makoctl reload
        '';
    };

    apply-theme-walker = pkgs.writeShellApplication {
        name = "apply-theme-walker";
        runtimeInputs = [ pkgs.systemd ];
        text = ''
            systemctl --user restart walker
        '';
    };

    apply-theme-alacritty = pkgs.writeShellApplication {
        name = "apply-theme-alacritty";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
            THEME_DIR=$1

            mkdir -p "$HOME/.config/alacritty"
            chmod 644 "$HOME/.config/alacritty/colors.toml" 2>/dev/null || true
            cp "$THEME_DIR/alacritty.toml" "$HOME/.config/alacritty/colors.toml"
            chmod 644 "$HOME/.config/alacritty/colors.toml"
        '';
    };

    apply-theme-btop = pkgs.writeShellApplication {
        name = "apply-theme-btop";
        runtimeInputs = [ pkgs.coreutils pkgs.procps ];
        text = ''
            THEME_DIR=$1

            mkdir -p "$HOME/.config/btop/themes"
            chmod 644 "$HOME/.config/btop/themes/current.theme" 2>/dev/null || true
            cp "$THEME_DIR/btop.theme" "$HOME/.config/btop/themes/current.theme"
            chmod 644 "$HOME/.config/btop/themes/current.theme"
            pkill -SIGUSR2 btop 2>/dev/null || true
        '';
    };

    apply-theme-nautilus = pkgs.writeShellApplication {
        name = "apply-theme-nautilus";
        runtimeInputs = [ pkgs.dconf ];
        text = ''
            ICON_THEME=$1
            dconf write /org/gnome/desktop/interface/icon-theme "'$ICON_THEME'"
        '';
    };

    apply-theme-swayosd = pkgs.writeShellApplication {
        name = "apply-theme-swayosd";
        runtimeInputs = [ pkgs.systemd ];
        text = ''
            systemctl --user restart swayosd-server 2>/dev/null || true
        '';
    };


    # ── Inactive ──────────────────────────────────────────
    apply-theme-waybar = pkgs.writeShellApplication {
        name = "apply-theme-waybar";
        runtimeInputs = [ pkgs.procps ];
        text = ''
            # SIGUSR2 triggers a CSS reload without restarting
            pkill -SIGUSR2 waybar 2>/dev/null || true
        '';
    };


    # ── Orchestration ──────────────────────────────────────────
    # Calls each programs theme application
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

        # Icon theme lookup — baked in at build time by Nix
        declare -A ICON_THEMES=(
            ${lib.concatStringsSep "\n        " (
                map (t: "[\"${t.name}\"]=\"${t.iconTheme}\"")
                config.myModules.themes.definitions
            )}
        )
        ICON_THEME="''${ICON_THEMES[$THEME]:-Yaru-blue}"

        ln -sfn "$THEME_DIR" "$HOME/.local/state/theme/current"
        echo "$THEME" > "$HOME/.local/state/theme/active-theme"

        ${apply-theme-eww}/bin/apply-theme-eww
        ${apply-theme-wallpaper}/bin/apply-theme-wallpaper "$THEME"
        ${apply-theme-hyprland}/bin/apply-theme-hyprland
        ${apply-theme-mako}/bin/apply-theme-mako "$THEME_DIR"
        ${apply-theme-walker}/bin/apply-theme-walker
        ${apply-theme-alacritty}/bin/apply-theme-alacritty "$THEME_DIR"
        ${apply-theme-btop}/bin/apply-theme-btop "$THEME_DIR"
        ${apply-theme-nautilus}/bin/apply-theme-nautilus "$ICON_THEME"
        ${apply-theme-swayosd}/bin/apply-theme-swayosd

        echo "Theme set to $THEME"
    '';
in

{
    # The callable script
    config = {
        home.packages = [ nix-theme-set ];
    };
}