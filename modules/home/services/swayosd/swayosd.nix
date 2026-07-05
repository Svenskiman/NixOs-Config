{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.swayosd.enable = lib.mkEnableOption "SwayOSD";
  };

  config = lib.mkIf config.myModules.swayosd.enable {

    home.packages = [ pkgs.swayosd ];

    systemd.user.services.swayosd-server = {
      Unit = {
        Description = "SwayOSD server";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.configFile."swayosd/style.css".text = ''
      @import "${config.home.homeDirectory}/.local/state/theme/current/swayosd.css";
    ''
    + builtins.readFile ./style.css;
  };
}
