{ hyprland-preview-share-picker, pkgs, lib, config, ... }:

{
    config = lib.mkIf config.myModules.hypr.enable {
        home.packages = [
            hyprland-preview-share-picker.packages.${pkgs.stdenv.hostPlatform.system}.default
            pkgs.slurp
        ];

        xdg.configFile."hypr/xdph.conf".text = ''
            screencopy {
                custom_picker_binary = hyprland-preview-share-picker
            }
        '';

        xdg.configFile."hyprland-preview-share-picker/config.yaml".text = ''
            stylesheets:
                - ${config.home.homeDirectory}/.local/state/theme/current/share-picker.css
            default_page: windows

            window:
                height: 500
                width: 1000

            windows:
                min_per_row: 3
                max_per_row: 999
                clicks: 2
                spacing: 12

            outputs:
                clicks: 2
                spacing: 6
                show_label: false
                respect_output_scaling: true

            region:
                command: slurp -f '%o@%x,%y,%w,%h'

            hide_token_restore: true
        '';
    };
}