{ lib, config, ... }:

let
    makeWorkspaceRuleLua = ws:
        "hl.workspace_rule({ workspace = ${toString ws.id}, monitor = \"${ws.monitor}\" })\n";
in

{
    options = {
        myModules.hypr.workspaceMonitors = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {
                options = {
                    id = lib.mkOption { type = lib.types.int; };
                    monitor = lib.mkOption { type = lib.types.str; };
                };
            });
            default = [];
            description = "Pins a workspace ID to always open on a specific monitor";
        };
    };

    config = lib.mkIf (config.myModules.hypr.enable && config.myModules.hypr.workspaceMonitors != []) {
        wayland.windowManager.hyprland.extraConfig = ''
            -- Workspace to Monitor Bindings --
        '' + lib.concatMapStrings makeWorkspaceRuleLua config.myModules.hypr.workspaceMonitors;
    };
}