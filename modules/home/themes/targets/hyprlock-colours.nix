{ lib, config, ... }:

let
    makeHyprLockConf = theme: ''
        $background = rgb(${lib.removePrefix "#" theme.colors.background})
        $inner_color = rgb(${lib.removePrefix "#" theme.colors.color0})
        $outer_color = rgb(${lib.removePrefix "#" theme.colors.accent})
        $font_color = rgb(${lib.removePrefix "#" theme.colors.foreground})
        $check_color = rgb(${lib.removePrefix "#" theme.colors.color2})
        $fail_color = rgb(${lib.removePrefix "#" theme.colors.color1})
    '';

    themeFiles = lib.listToAttrs (map (theme: {
        name = "themes/${theme.name}/hyprlock.conf";
        value = { text = makeHyprLockConf theme; };
    }) config.myModules.themes.definitions);
in

{
    config = lib.mkIf config.myModules.hyprlock.enable {
        xdg.configFile = themeFiles;
    };
}