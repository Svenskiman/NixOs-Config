{ lib, config, ... }:

let
    # Convert a hex colour #RRGGBB to Hyprland's rgba(RRGGBBaa) format
    toRgba = hex: opacity:
        "rgba(${lib.removePrefix "#" hex}${opacity})";

    makeHyprlandScript = theme: ''
        ACTIVE_BORDER="${toRgba theme.colors.accent "ee"}"
        INACTIVE_BORDER="${toRgba theme.colors.background "aa"}"
    '';

    themeFiles = lib.listToAttrs (map (theme: {
        name  = "themes/${theme.name}/hyprland-colours.sh";
        value = { text = makeHyprlandScript theme; };
    }) config.myModules.themes.definitions);
in

{
    config = {
        xdg.configFile = themeFiles;
    };
}