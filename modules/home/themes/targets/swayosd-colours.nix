{ lib, config, ... }:

let
    makeSwayOSDCSS = theme: ''
        @define-color background     ${theme.colors.background};
        @define-color border         ${theme.colors.accent};
        @define-color foreground     ${theme.colors.foreground};
        @define-color theme_fg_color ${theme.colors.foreground};
        @define-color progress-fill  ${theme.colors.accent};
        @define-color progress-empty ${theme.colors.color8};
    '';

    themeFiles = lib.listToAttrs (map (theme: {
        name  = "themes/${theme.name}/swayosd.css";
        value = { text = makeSwayOSDCSS theme; };
    }) config.myModules.themes.definitions);
in

{
    config = lib.mkIf config.myModules.swayosd.enable {
        xdg.configFile = themeFiles;
    };
}