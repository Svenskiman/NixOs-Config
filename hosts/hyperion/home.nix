{ pkgs, config, ... }:

{
    imports = [
        ./../../modules/home/config/zsh.nix
    ];

    home.username = "shrike";
    home.homeDirectory = "/home/shrike";
    home.stateVersion = "26.05";

    myModules.zsh.enable = true;

    home.packages = with pkgs; [
        git
        wget
        fastfetch
        eza
    ];
}