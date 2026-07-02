{ pkgs, lib, config, ... }:

{
    config = lib.mkIf config.myModules.hypr.enable {
        xdg.portal = {
            enable = true;

            extraPortals = [
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-hyprland
                pkgs.xdg-desktop-portal-gnome
            ];

            configPackages = [
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-hyprland
                pkgs.xdg-desktop-portal-gnome
            ];

            config.common = {
                default = [ "hyprland" "gtk" ];

                # GNOME portal has no working ScreenCast backend without gnome-shell running
                "org.freedesktop.impl.portal.Settings" = "gnome";
                "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
            };
        };
    };
}