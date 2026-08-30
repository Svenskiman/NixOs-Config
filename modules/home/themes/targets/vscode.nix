{
  lib,
  config,
  pkgs,
  ...
}:

let
  makeVscodeJSON =
    theme:
    builtins.toJSON {
      name = theme.vscode.name;
      extension = theme.vscode.extension;
      settings = theme.vscode.settings;
    };

  themeFiles = lib.listToAttrs (
    lib.concatMap (
      theme:
      if theme.vscode != null then
        [
          {
            name = "themes/${theme.name}/vscode.json";
            value = {
              text = makeVscodeJSON theme;
            };
          }
        ]
      else
        [ ]
    ) config.myModules.themes.definitions
  );

  apply-theme-vscode = pkgs.writeShellApplication {
    name = "apply-theme-vscode";
    runtimeInputs = [
      pkgs.jq
      pkgs.coreutils
    ];
    text = ''
      THEME_DIR=$2
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

      # VS Code isn't a Nix package here — skip if it isn't on PATH
      if ! command -v code >/dev/null 2>&1; then
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
in

{
  config = {
    xdg.configFile = themeFiles;

    myModules.themes.hooks = [
      {
        name = "apply-theme-vscode";
        package = apply-theme-vscode;
      }
    ];
  };
}
