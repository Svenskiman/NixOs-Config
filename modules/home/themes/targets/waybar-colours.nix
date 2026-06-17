{ lib, config, ... }:

let
    # Generate a waybar CSS file from a theme definition.
    # Iterates over the colour attrset and emits one @define-color line per key.
    makeWaybarCSS = theme:
        lib.concatStringsSep "\n" (
            lib.mapAttrsToList
                (name: value: "@define-color ${name} ${value};")
                theme.colors
        );

    # Build a home.file attrset entry for each theme.
    # Results in ~/.config/themes/<name>/waybar.css per theme.
    themeFiles = lib.listToAttrs (map (theme: {
        name  = "themes/${theme.name}/waybar.css";
        value = { text = makeWaybarCSS theme; };
    }) config.myModules.themes.definitions);

in
{
    config = {
        xdg.configFile = themeFiles;
    };
}