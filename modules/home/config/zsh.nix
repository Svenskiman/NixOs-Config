{
  lib,
  config,
  pkgs,
  ...
}:

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

      # Alias eza with ls
      shellAliases = {
        ls = "eza -lh --group-directories-first --icons=auto";
        lsa = "eza -lha --group-directories-first --icons=auto";
        lt = "eza --tree --level=2 --long --icons --git";
        lta = "eza --tree --level=2 --long --icons --git -a";
      };

      # Case insensitive tab completion
      initContent = ''
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      '';
    };

    programs.starship = {
      enable = true;

      # <user>@<host> <dir> git:(<branch>) ❯
      # hostname and username only shown over SSH
      settings = {
        format = "$username$hostname$directory$git_branch$character";

        username = {
          show_always = false;
          format = "[$user](bold cyan)";
        };

        hostname = {
          ssh_only = true;
          format = "[@$hostname](bold cyan) ";
          disabled = false;
        };

        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold cyan";
          format = "[$path]($style) ";
        };

        git_branch = {
          format = "[git:\\(](bold blue)[$branch](bold red)[\\)](bold blue) ";
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
