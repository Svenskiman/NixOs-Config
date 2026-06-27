{ lib, config, pkgs, ... }:

let
    makeVscodeJSON = theme:
        builtins.toJSON {
            name      = theme.vscode.name;
            extension = theme.vscode.extension;
            settings  = theme.vscode.settings;
        };

    themeFiles = lib.listToAttrs (
        lib.concatMap (theme:
            if theme.vscode != null then [{
                name  = "themes/${theme.name}/vscode.json";
                value = { text = makeVscodeJSON theme; };
            }] else []
        ) config.myModules.themes.definitions
    );
in

{
    config = {
        xdg.configFile = themeFiles;
    };
}