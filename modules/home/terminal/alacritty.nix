{ lib, config, ... }:

{
    options = {
        myModules.alacritty.enable = lib.mkEnableOption "Alacritty terminal config";
    };

    config = lib.mkIf config.myModules.alacritty.enable {

        programs.alacritty = {
            enable = true;
            settings = {
                general.import = [ "/home/svenski/.config/alacritty/colors.toml" ];
                window = {
                    padding = {
                        x = 8;
                        y = 8;
                    };
                    decorations = "none";
                };
            };
        };

    };
}