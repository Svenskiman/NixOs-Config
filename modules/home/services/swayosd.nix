{ lib, config, pkgs, ... }:

{
    options = {
        myModules.swayosd.enable = lib.mkEnableOption "SwayOSD";
    };

    config = lib.mkIf config.myModules.swayosd.enable {

        home.packages = [ pkgs.swayosd ];

        systemd.user.services.swayosd-server = {
            Unit = {
                Description = "SwayOSD server";
                PartOf      = [ "graphical-session.target" ];
                After       = [ "graphical-session.target" ];
            };
            Service = {
                ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
                Restart   = "on-failure";
            };
            Install = {
                WantedBy = [ "graphical-session.target" ];
            };
        };

        xdg.configFile."swayosd/style.css".text = ''
            @import "/home/svenski/.local/state/theme/current/swayosd.css";

            window {
                border-radius: 12px;
                opacity:       0.97;
                border:        1px solid @border;
                background:    @background;
            }

            #container {
                padding: 12px 24px;
            }

            #icon {
                color:      @foreground;
                min-width:  24px;
                min-height: 24px;
            }

            #label {
                color:     @foreground;
                font-size: 13px;
                margin:    0 8px;
            }

            progressbar,
            progress {
                min-height:    4px;
                border-radius: 9999px;
            }

            progressbar {
                background: @progress-empty;
            }

            progress {
                background: @progress-fill;
            }
        '';
    };
}