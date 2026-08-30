{
  lib,
  pkgs,
  config,
  ...
}:

let
  makeSwayOSDCSS = theme: ''
    @define-color background     ${theme.colors.background};
    @define-color border         ${theme.colors.accent};
    @define-color foreground     ${theme.colors.foreground};
    @define-color theme_fg_color ${theme.colors.foreground};
    @define-color progress-fill  ${theme.colors.accent};
    @define-color progress-empty ${theme.semantic.muted};
  '';

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/swayosd.css";
      value = {
        text = makeSwayOSDCSS theme;
      };
    }) config.myModules.themes.definitions
  );

  apply-theme-swayosd = pkgs.writeShellApplication {
    name = "apply-theme-swayosd";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      systemctl --user restart swayosd-server 2>/dev/null || true
    '';
  };
in

{
  config = lib.mkIf config.myModules.swayosd.enable {
    xdg.configFile = themeFiles;

    myModules.themes.hooks = [
      {
        name = "apply-theme-swayosd";
        package = apply-theme-swayosd;
      }
    ];
  };
}
