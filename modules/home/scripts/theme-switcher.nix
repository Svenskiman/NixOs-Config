{
  pkgs,
  lib,
  config,
  ...
}:

let
  # Logic for applying themes to a specific program

  apply-theme-eww = pkgs.writeShellApplication {
    name = "apply-theme-eww";
    runtimeInputs = [
      pkgs.eww
      pkgs.procps
      pkgs.coreutils
    ];
    text = ''
      # Close windows gracefully first so GTK can tear down Wayland surfaces
      eww close-all 2>/dev/null || true
      sleep 0.3

      # Kill the daemon cleanly (SIGTERM, not SIGKILL) so it releases the compositor connection
      eww kill 2>/dev/null || true
      sleep 0.3

      # If it's still hanging around, force it
      pkill -9 -x eww 2>/dev/null || true
      sleep 0.2

      # Fresh start
      eww daemon 2>/dev/null
      sleep 0.5
      eww open bar 2>/dev/null || true
    '';
  };

  apply-theme-wallpaper = pkgs.writeShellApplication {
    name = "apply-theme-wallpaper";
    runtimeInputs = [
      pkgs.findutils
      pkgs.coreutils
    ];
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
    runtimeInputs = [
      pkgs.mako
      pkgs.coreutils
    ];
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
    runtimeInputs = [
      pkgs.coreutils
      pkgs.procps
    ];
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

  apply-theme-vscode = pkgs.writeShellApplication {
    name = "apply-theme-vscode";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      THEME_DIR=$1
      VSCODE_JSON="$THEME_DIR/vscode.json"
      SETTINGS="$HOME/.config/Code/User/settings.json"

      # Theme has no VS Code mapping — leave settings.json untouched
      if [ ! -f "$VSCODE_JSON" ]; then
          exit 0
      fi

      # settings.json must exist before we can patch it
      if [ ! -f "$SETTINGS" ]; then
          exit 0
      fi

      THEME_NAME=$(jq -r '.name' "$VSCODE_JSON")
      EXTENSION=$(jq -r '.extension' "$VSCODE_JSON")

      # Install extension if not already present
      if ! code --list-extensions 2>/dev/null | grep -qi "^''${EXTENSION}$"; then
          code --install-extension "$EXTENSION" --force 2>/dev/null || true
      fi

      # Merge workbench.colorTheme and any extra settings into settings.json
      EXTRA=$(jq '.settings' "$VSCODE_JSON")
      jq --arg theme "$THEME_NAME" \
      --argjson extra "$EXTRA" \
      '. + {"workbench.colorTheme": $theme} + $extra' \
      "$SETTINGS" > /tmp/vscode-settings.json \
      && mv /tmp/vscode-settings.json "$SETTINGS"
    '';
  };

  apply-theme-neovim = pkgs.writeShellApplication {
    name = "apply-theme-neovim";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
       THEME_DIR=$1
      NEOVIM_FILE="$THEME_DIR/neovim.lua"

       if [ -f "$NEOVIM_FILE" ]; then
           CS=$(cat "$NEOVIM_FILE")
           nvim --headless -c "colorscheme $CS" -c "qa" 2>/dev/null || true
       fi
    '';
  };

  apply-theme-opencode = pkgs.writeShellApplication {
    name = "apply-theme-opencode";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      THEME=$1
      TUI_JSON="$HOME/.config/opencode/tui.json"

      if [ ! -f "$TUI_JSON" ]; then
          jq -n '{"$schema":"https://opencode.ai/tui.json"}' > "$TUI_JSON"
      fi

      jq --arg theme "$THEME" \
         '. + {"theme": $theme}' \
         "$TUI_JSON" > /tmp/opencode-tui.json \
      && mv /tmp/opencode-tui.json "$TUI_JSON"
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
          map (t: "[\"${t.name}\"]=\"${t.iconTheme}\"") config.myModules.themes.definitions
        )}
    )
    ICON_THEME="''${ICON_THEMES[$THEME]:-Yaru-blue}"

    ln -sfn "$THEME_DIR" "$HOME/.local/state/theme/current"
    echo "$THEME" > "$HOME/.local/state/theme/active-theme"

    ${apply-theme-wallpaper}/bin/apply-theme-wallpaper "$THEME"
    ${apply-theme-hyprland}/bin/apply-theme-hyprland
    ${apply-theme-eww}/bin/apply-theme-eww
    sleep 0.5
    ${apply-theme-mako}/bin/apply-theme-mako "$THEME_DIR"
    ${apply-theme-walker}/bin/apply-theme-walker
    ${apply-theme-alacritty}/bin/apply-theme-alacritty "$THEME_DIR"
    ${apply-theme-btop}/bin/apply-theme-btop "$THEME_DIR"
    ${apply-theme-nautilus}/bin/apply-theme-nautilus "$ICON_THEME"
    ${apply-theme-swayosd}/bin/apply-theme-swayosd
    ${apply-theme-vscode}/bin/apply-theme-vscode "$THEME_DIR"
    ${apply-theme-neovim}/bin/apply-theme-neovim "$THEME_DIR"
    ${apply-theme-opencode}/bin/apply-theme-opencode "$THEME" 

    echo "Theme set to $THEME"
  '';
in

{
  # The callable script
  config = {
    home.packages = [ nix-theme-set ];
  };
}
