{ ... }:

{
    imports = [
        ./nix-settings.nix
        ./fonts.nix
        ./users.nix
        ./boot
        ./hardware
        ./services
        ./networking
        ./secrets.nix
    ];
}