{ pkgs, lib, config, ... }:

let
    eww-dropdown-toggle = pkgs.writeShellApplication {
        name = "eww-dropdown-toggle";
        runtimeInputs = [ pkgs.eww ];
        text = ''
            if eww active-windows | grep -q "dropdown"; then
                eww close dropdown
            else
                eww open dropdown
            fi
        '';
    };
in

{
    config = lib.mkIf config.myModules.eww.enable {
        home.packages = [ eww-dropdown-toggle ];
    };
}