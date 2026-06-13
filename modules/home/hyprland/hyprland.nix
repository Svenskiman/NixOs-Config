{ lib, config, ... }:

{
    imports = [
        ./autostart.nix
        ./bindings.nix
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

        # Define the Hyprland config that Home Manager generates
        # myModules.hypr.bindings.enable = true;
        # myModules.hypr.autostart.enable = true;
    };
}