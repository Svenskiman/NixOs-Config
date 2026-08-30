{
  lib,
  pkgs,
  config,
  ...
}:

let
  # Convert #RRGGBB to Hyprland's rgba(RRGGBBaa) format
  toRgba = hex: opacity: "rgba(${lib.removePrefix "#" hex}${opacity})";

  makeHyprlandLua = theme: ''
    hl.config({
        general = {
            col = {
                active_border   = "${toRgba theme.colors.accent "ee"}",
                inactive_border = "${toRgba theme.colors.background "aa"}",
            },
        },
    })
  '';

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/hyprland-colours.lua";
      value = {
        text = makeHyprlandLua theme;
      };
    }) config.myModules.themes.definitions
  );

  apply-theme-hyprland = pkgs.writeShellApplication {
    name = "apply-theme-hyprland";
    runtimeInputs = [ pkgs.hyprland ];
    text = ''
      hyprctl reload > /dev/null 2>&1
    '';
  };
in

{
  config = lib.mkIf config.myModules.hypr.enable {
    xdg.configFile = themeFiles;

    myModules.themes.hooks = [
      {
        name = "apply-theme-hyprland";
        package = apply-theme-hyprland;
      }
    ];
  };
}
