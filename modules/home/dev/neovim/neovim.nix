{ lib, config, ... }:

{
    options = {
        myModules.neovim.enable = lib.mkEnableOption "LazyVim";
    };

    config = lib.mkIf config.myModules.neovim.enable {
        programs.lazyvim = {
            enable = true;
            installCoreDependencies = true;

            plugins = {
                colorscheme = builtins.readFile ./plugins/themes.lua;
                snacks = builtins.readFile ./plugins/snacks.lua;
            };

            config = {
                options = builtins.readFile ./config/options.lua;
            };
        };
    };
}
