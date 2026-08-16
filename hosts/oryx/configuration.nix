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
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 4;
}
