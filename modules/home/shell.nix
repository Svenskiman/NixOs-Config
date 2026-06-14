{ lib, config, pkgs, ... }:

{
  options = {
    myModules.shell.enable = lib.mkEnableOption "Zsh shell config";
  };

  config = lib.mkIf config.myModules.shell.enable {

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

      initContent = ''
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      '';
    };

    programs.starship = {
      enable = true;
      settings = {
        format = " $directory$git_branch$git_status$character";
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold blue";
        };
        git_branch = {
          format = "[$branch $symbol]($style) ";
          symbol = "";
          style = "italic red";
        };
        git_status = {
          format = "([$all_status$ahead_behind]($style))";
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