{ ... }:

{
  imports = [
    ./nix-settings.nix
    ./fonts.nix
    ./users.nix
    ./boot
    ./hardware
    ./services
    ./servers
    ./networking
    ./secrets.nix
  ];
}
