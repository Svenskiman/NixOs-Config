{
  lib,
  pkgs,
  config,
  ...
}:

let
  iconThemes = lib.listToAttrs (
    map (theme: {
      name = theme.name;
      value = theme.iconTheme;
    }) config.myModules.themes.definitions
  );

  apply-theme-nautilus = pkgs.writeShellApplication {
    name = "apply-theme-nautilus";
    runtimeInputs = [ pkgs.dconf ];
    text = ''
      THEME=$1

      declare -A ICON_THEMES=(
          ${lib.concatStringsSep "\n          " (
            lib.mapAttrsToList (name: icon: "[\"${name}\"]=\"${icon}\"") iconThemes
          )}
      )
      ICON_THEME="''${ICON_THEMES[$THEME]:-Yaru-blue}"

      dconf write /org/gnome/desktop/interface/icon-theme "'$ICON_THEME'"
    '';
  };
in

{
  config = lib.mkIf config.myModules.nautilus.enable {
    myModules.themes.hooks = [
      {
        name = "apply-theme-nautilus";
        package = apply-theme-nautilus;
      }
    ];
  };
}
