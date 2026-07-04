{ config, lib, ... }:

{
    options = {
        myModules.secrets.enable = lib.mkEnableOption "sops-nix secrets";
    };

    config = lib.mkIf config.myModules.secrets.enable {
        sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        sops.defaultSopsFormat = "yaml";
    };
}