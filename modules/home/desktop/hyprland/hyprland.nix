{ lib, config, ... }:

{
    imports = [
        ./autostart.nix
        ./bindings.nix
        ./clamshell-binds.nix
        ./looknfeel.nix
        ./input.nix
        ./windowrules.nix
        ./env.nix
        ./monitors.nix
    ];

    # Allow Home Manger to manage Hyprland and activate my submodules
    options = {
        myModules.hypr.enable = lib.mkEnableOption "Enable Hyprland";
    };

    config = lib.mkIf config.myModules.hypr.enable {

        # Allow Home Manager to manage Hyprland config
        wayland.windowManager.hyprland = {
            enable = true;
        };
    };
}