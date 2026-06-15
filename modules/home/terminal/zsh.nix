{ lib, config, pkgs, ... }:

{
    options = {
        myModules.zsh.enable = lib.mkEnableOption "Zsh shell config";
    };

    config = lib.mkIf config.myModules.zsh.enable {

        programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            historySubstringSearch.enable = true;

            history = {
                size = 10000;
                ignoreDups = true;
                share = true;
            };

			# Case insensitive tab completion
            initContent = ''
                zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
            '';
        };

        programs.starship = {
            enable = true;

			# <dir> git:(<branch>) ❯
            settings = {
                format = "$directory$git_branch$character";

                directory = {
                    truncation_length = 3;
                    truncate_to_repo = true;
                    style = "bold cyan";
                    format = "[$path]($style) ";
                };

                git_branch = {
                    format = "[git:\\(](bold blue)[$branch](bold #E06C75)[\\)](bold blue) ";
                };

                character = {
                    success_symbol = "[❯](green)";
                    error_symbol = "[❯](red)";
                };
            };
        };

        home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

    };
}