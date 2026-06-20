{ lib, config, ... }:

let
    # Generate an eww SCSS file from a theme definition.
    # Iterates over the colour attrset and emits one @define-color line per key.
    makeEwwCSS = theme:
        lib.concatStringsSep "\n" (
            lib.mapAttrsToList
                (name: value: "@define-color ${name} ${value};")
                theme.colors
        );

    # Build a home.file attrset entry for each theme.
    # Results in ~/.config/themes/<name>/eww.css per theme.
    themeFiles = lib.listToAttrs (map (theme: {
            name  = "themes/${theme.name}/eww.css";
            value = { text = makeEwwCSS theme; };
    }) config.myModules.themes.definitions);
in

{
    config = lib.mkIf config.myModules.eww.enable {
        xdg.configFile = themeFiles;
    };
}