{ lib, config, ... }:

let
  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/quickshell.json";
      value = {
        text = builtins.toJSON {
          inherit (theme) name displayName;
          inherit (theme) colors semantic;
        };
      };
    }) config.myModules.themes.definitions
  );
in

{
  config = lib.mkIf config.myModules.quickshell.enable {
    xdg.configFile = themeFiles;
  };
}
