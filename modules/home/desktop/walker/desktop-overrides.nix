{ lib, config, ... }:

let
    # Desktop entries to hide from Walker entirely
    hiddenApps = [
        "btop"
        "dropbox"
        "org.gnome.Nautilus"
        "gvim"
        "vim"
        "uuctl"
    ];

    # Override existing desktop entries with a custom name, icon and exec.
    # Find correct values with:
    # cat /etc/profiles/per-user/<user>/share/applications/<name>.desktop
    overriddenApps = [
        {
            file = "mpv";
            name = "Media Player";
            icon = "mpv";
            exec = "mpv --player-operation-mode=pseudo-gui -- %U";
        }
        {
            file = "kitty";
            name = "Kitty";
            icon = "kitty";
            exec = "kitty";
        }
    ];

    # Custom desktop entries with no corresponding system entry.
    customApps = [
        {
            file = "nixconf-settings";
            name = "Settings";
            icon = "preferences-system";
            exec = "code /home/svenski/.config/nixconf";
        }
    ];

    # Shared template for overridden and custom entries
    makeEntry = app: {
        name  = "applications/${app.file}.desktop";
        value = { text = ''
            [Desktop Entry]
            Type=Application
            Name=${app.name}
            Icon=${app.icon}
            Exec=${app.exec}
            Terminal=false
        ''; };
    };
in

{
    config = lib.mkIf config.myModules.walker.enable {
        xdg.dataFile =
            # Convert each list into an attrset of { "path" = { text = "..."; }; }
            # then merge them with // into one attrset for xdg.dataFile
            lib.listToAttrs (map (app: {
                name  = "applications/${app}.desktop";
                value = { text = "[Desktop Entry]\nNoDisplay=true\n"; };
            }) hiddenApps)
            //
            lib.listToAttrs (map makeEntry overriddenApps)
            //
            lib.listToAttrs (map makeEntry customApps);
    };
}