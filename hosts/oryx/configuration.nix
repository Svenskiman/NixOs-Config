{ pkgs, ... }: {
  networking.hostName = "oryx";

  users.users.benmiller = {
    home = "/Users/benmiller";
    shell = pkgs.zsh;
    uid = 502;
  };
  users.knownUsers = [ "benmiller" ];

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [ 
    alacritty 
    vscode
  ];

  # Homebrew casks
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";   # removes casks not listed here on rebuild
    };
    casks = [
      "jetbrains-toolbox"
      "docker-desktop"
      "sublime-text"
      "spotify"
    ];
  };

  system.primaryUser = "benmiller";
  nixpkgs.hostPlatform = "aarch64-darwin";

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
