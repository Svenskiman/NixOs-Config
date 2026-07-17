{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.neovim.enable = lib.mkEnableOption "LazyVim";
  };

  config = lib.mkIf config.myModules.neovim.enable {
    programs.lazyvim = {
      enable = true;
      installCoreDependencies = true;

      extras = {
        lang.nix = {
          enable = true;
          installDependencies = false;
        };
      };

      extraPackages = with pkgs; [
        nixd
        statix
        lua-language-server
        nixfmt
        basedpyright
        ruff
      ];

      plugins = {
        colorscheme = builtins.readFile ./plugins/themes.lua;
        snacks = builtins.readFile ./plugins/snacks.lua;
        lang = builtins.readFile ./plugins/lang.lua;
        brackets = builtins.readFile ./plugins/brackets.lua;
        inlayhint = builtins.readFile ./plugins/inlayhint.lua;
      };

      config = {
        options = builtins.readFile ./config/options.lua;
      };
    };
  };
}
