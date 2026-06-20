{ lib, config, ... }:

let
    # Use the first theme definition as the default theme
    defaultTheme = builtins.head config.myModules.themes.definitions;
in

{

    imports = [ 
        ./menus/theme-switcher.nix
        ./menus/wallpaper-switcher.nix
    ];

    options = {
        myModules.walker.enable = lib.mkEnableOption "Walker";
    };

    config = lib.mkIf config.myModules.walker.enable {
        programs.walker = {
            enable = true;
            runAsService = true;

            # Global config — behaviour, providers, dimensions
            config = (import ./config.nix) // {
                theme = defaultTheme.name;
            };

            # Load colour variables from the active theme at runtime.
            # Must come before style.nix so variables are defined before use.
            themes.${defaultTheme.name} = {
                style = ''
                    @import "/home/svenski/.local/state/theme/current/walker.css";
                '' + (import ./style.nix);

                # layouts.layout = builtins.readFile ./layout.xml;
            };
        };
    };
}