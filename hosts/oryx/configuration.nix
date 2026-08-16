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
  system.primaryUser = "benmiller";
  nixpkgs.hostPlatform = "aarch64-darwin";

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
