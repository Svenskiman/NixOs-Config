{ lib, config, pkgs, ... }:

{
    options.myModules.dropbox.enable = lib.mkEnableOption "Dropbox sync";

    config = lib.mkIf config.myModules.dropbox.enable {
        services.dropbox.enable = true;

        systemd.user.services.dropbox.Service = {
            Type = lib.mkForce "simple";
            PIDFile = lib.mkForce "";
            ExecStart = lib.mkForce "${pkgs.writeShellScript "dropbox-start-fg" ''
                HOME=${config.home.homeDirectory}/.dropbox-hm
                export HOME

                mkdir -p "$HOME"/{.dropbox,.dropbox-dist,Dropbox}

                if [[ ! -d ${config.home.homeDirectory}/.dropbox ]]; then
                    ln -s "$HOME/.dropbox" ${config.home.homeDirectory}/.dropbox
                fi

                if [[ ! -f "$HOME/.dropbox-dist/VERSION" ]]; then
                    yes | ${lib.getExe' pkgs.dropbox-cli "dropbox"} update
                fi

                DROPBOX_BIN=$(find "$HOME/.dropbox-dist" -maxdepth 1 -type d -name 'dropbox-lnx*' | sort -V | tail -1)/dropbox
                exec "$DROPBOX_BIN"
            ''}";
        };
    };
}