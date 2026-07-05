{ lib, config, ... }:

{
    options = {
        myModules.alacritty.enable = lib.mkEnableOption "Alacritty terminal config";
    };

    config = lib.mkIf config.myModules.alacritty.enable {

        programs.alacritty = {
            enable = true;
            settings = {
                general.import = [ "${config.home.homeDirectory}/.config/alacritty/colors.toml" ];
                window = {
                    padding = {
                        x = 16;
                        y = 8;
                    };
                    decorations = "none";
                };
                font = {
                        normal = {
                            family = "JetBrainsMono Nerd Font";
                            style = "Regular";
                        };
                };
            };
        };
    };
}
