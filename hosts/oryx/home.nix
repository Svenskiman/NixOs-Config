{ pkgs, lib, ... }:
{
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

  programs.alacritty.settings.window.decorations = lib.mkForce "full";
  programs.alacritty.settings.general.import = lib.mkForce [ ];

  programs.alacritty.settings.colors = {
    primary = {
      background = "#282828";
      foreground = "#E2CCA9";
    };
    cursor = {
      text = "#282828";
      cursor = "#E2CCA9";
    };
    selection = {
      text = "#E2CCA9";
      background = "#45403D";
    };
    normal = {
      black = "#1B1B1B";
      red = "#F2594B";
      green = "#B0B846";
      yellow = "#E9B143";
      blue = "#80AA9E";
      magenta = "#D3869B";
      cyan = "#8BBA7F";
      white = "#A89984";
    };
    bright = {
      black = "#45403D";
      red = "#F2594B";
      green = "#B0B846";
      yellow = "#E9B143";
      blue = "#80AA9E";
      magenta = "#D3869B";
      cyan = "#8BBA7F";
      white = "#E2CCA9";
    };
  };
}