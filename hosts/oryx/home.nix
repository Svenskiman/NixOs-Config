{ pkgs, ... }: {
  imports = [
    ../../modules/home/config/zsh.nix
    ../../modules/home/apps/btop.nix
    ../../modules/home/apps/alacritty.nix
  ];

  myModules = {
    zsh.enable = true;
    btop.enable = true;
    alacritty.enable = true;
  };

  home = {
    username = "benmiller";
    homeDirectory = "/Users/benmiller";
    stateVersion = "24.11";

    packages = with pkgs; [
      wget
      git
      fastfetch
      eza
      lazydocker
    ];
  };
}
