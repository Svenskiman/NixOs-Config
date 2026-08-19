{
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.macSettings;
in
{
  options.myModules.macSettings.enable = lib.mkEnableOption "macOS system settings";

  config = lib.mkIf cfg.enable {
    system.defaults = {
      # Global
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
      };

      # Dock
      dock = {
        launchanim = false;
        mru-spaces = false; # Don't rearrange spaces based on most recent use
      };

      # Screenshots
      screencapture.location = "~/Pictures/Screenshots";
    };

    # Keyboard shortcuts (Mission Control)
    # Parameters format: (ASCII code, key code, modifier flags)
    # Modifier flags: 262144 = Control
    system.defaults.CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # ⌃1 - Move left a space
          "79" = {
            enabled = true;
            value = {
              parameters = [ 49 18 262144 ];
              type = "standard";
            };
          };
          # ⌃2 - Move right a space
          "81" = {
            enabled = true;
            value = {
              parameters = [ 50 19 262144 ];
              type = "standard";
            };
          };
          # ⌃3 - Switch to Desktop 1
          "118" = {
            enabled = true;
            value = {
              parameters = [ 51 20 262144 ];
              type = "standard";
            };
          };
        };
      };
    };
  };
}
