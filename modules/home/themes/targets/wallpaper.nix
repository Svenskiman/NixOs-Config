{
  lib,
  pkgs,
  config,
  ...
}:

let
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
in

{
  config = lib.mkIf config.myModules.wallpaper.enable {
    myModules.themes.hooks = [
      {
        name = "apply-theme-wallpaper";
        package = apply-theme-wallpaper;
        priority = 10;
      }
    ];
  };
}
