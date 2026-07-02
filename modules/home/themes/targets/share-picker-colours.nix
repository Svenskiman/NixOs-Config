{ lib, config, ... }:

let
    makeSharePickerCSS = theme: ''
        * {
            all: unset;
            font-family: "JetBrainsMono Nerd Font";
            font-weight: bold;
            font-size: 16px;
            color: ${theme.colors.foreground};
        }

        .window {
            border-radius: 8px;
            background-color: ${theme.colors.background};
            border: solid 2px ${theme.colors.color8};
            margin: 2px;
        }

        tabs {
            padding: 0.5rem 1rem;
        }

        tabs > tab {
            margin-right: 1rem;
        }

        .tab-label {
            color: ${theme.colors.color8};
            transition: all 0.2s ease;
        }

        tabs > tab:checked > .tab-label,
        tabs > tab:active > .tab-label {
            text-decoration: underline currentColor;
            color: ${theme.colors.foreground};
        }

        tabs > tab:focus > .tab-label {
            color: ${theme.colors.foreground};
        }

        .page {
            padding: 1rem;
        }

        .image-label {
            font-size: 12px;
            padding: 0.25rem;
        }

        flowboxchild > .card,
        button > .card {
            transition: all 0.2s ease;
            border: solid 2px transparent;
            border-color: ${theme.colors.color0};
            border-radius: 8px;
            background-color: ${theme.colors.color0};
            padding: 5px;
        }

        flowboxchild:active > .card,
        flowboxchild:selected > .card,
        button:active > .card,
        button:selected > .card,
        button:focus > .card {
            border: solid 2px ${theme.colors.accent};
        }

        .image {
            border-radius: 5px;
        }

        .region-button {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            background-color: ${theme.colors.accent};
            color: ${theme.colors.background};
            transition: all 0.2s ease;
        }

        .region-button:not(:disabled):hover,
        .region-button:not(:disabled):focus {
            background-color: ${theme.colors.color4};
        }

        .region-button:disabled {
            background-color: ${theme.colors.color8};
            color: ${theme.colors.color0};
        }
    '';

    themeFiles = lib.listToAttrs (map (theme: {
        name  = "themes/${theme.name}/share-picker.css";
        value = { text = makeSharePickerCSS theme; };
    }) config.myModules.themes.definitions);
in

{
    config = lib.mkIf config.myModules.hypr.enable {
        xdg.configFile = themeFiles;
    };
}