{ pkgs, ... }:

{
  networking.hostName = "oryx";

  users.users.benmiller = {
    home = "/Users/benmiller";
    shell = pkgs.zsh;
    uid = 502;
  };
  users.knownUsers = [ "benmiller" ];

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # Darwin modules
  myModules = {
    nix.enable = true;
    homebrew = {
      enable = true;
      brews = [ "ddev/ddev/ddev" ];
      casks = [
        "alacritty"
        "discord"
        "docker-desktop"
        "jetbrains-toolbox"
        "keepassxc"
        "kiro"
        "spotify"
        "sublime-text"
      ];
    };
  };

  system.primaryUser = "benmiller";
  nixpkgs.hostPlatform = "aarch64-darwin";
  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
