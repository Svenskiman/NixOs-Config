{ pkgs, ... }: {
  networking.hostName = "oryx";

  users.users.benmiller = {
    home = "/Users/benmiller";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  environment.systemPackages = [ pkgs.alacritty ];

  system.primaryUser = "benmiller";
  nixpkgs.hostPlatform = "aarch64-darwin";

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
