{ pkgs, lib, ... }:

{
    config = {
        home.activation.copyPapirusIcons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p "$HOME/.local/share/icons"
            for variant in Papirus Papirus-Dark Papirus-Light; do
                dest="$HOME/.local/share/icons/$variant"
                if [ ! -d "$dest" ]; then
                    cp -r "${pkgs.papirus-icon-theme}/share/icons/$variant" "$dest"
                    chmod -R u+w "$dest"
                fi
            done
        '';
    };
}