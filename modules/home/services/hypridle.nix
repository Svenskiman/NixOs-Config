{ lib, config, ... }:

{
    options = {
        myModules.hypridle.enable = lib.mkEnableOption "Hypridle idle daemon";
    };

    config = lib.mkIf config.myModules.hypridle.enable {
        services.hypridle = {
            enable = true;
            settings = {
                general = {
                    lock_cmd = "pidof hyprlock || hyprlock";
                    before_sleep_cmd = "loginctl lock-session";
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                };

                listener = [

                    # Dim brightness after 2.5 min as an idle warning
                    {
                        timeout = 150;
                        on-timeout = "brightnessctl -s set 20%";
                        on-resume = "brightnessctl -r";
                    }

                    # Lock after 5 min
                    {
                        timeout = 300;
                        on-timeout = "loginctl lock-session";
                    }

                    # Turn displays off after 5.5 min
                    {
                        timeout = 330;
                        on-timeout = "hyprctl dispatch dpms off";
                        on-resume = "hyprctl dispatch dpms on";
                    }

                    # Suspend after 20 min
                    {
                        timeout = 1200;
                        on-timeout = "systemctl suspend";
                    }
                ];
            };
        };
    };
}