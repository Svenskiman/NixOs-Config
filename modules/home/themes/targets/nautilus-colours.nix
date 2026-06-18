{ lib, config, ... }:

let
    themeFiles = lib.listToAttrs (map (theme: {
        name  = "themes/${theme.name}/folder-color";
        value = { text = theme.folderColor; };
    }) config.myModules.themes.definitions);
in

{
    config = {
        xdg.configFile = themeFiles;
    };
}