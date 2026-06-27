{ pkgs, ... }:

{
    users.users.svenski = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
        shell = pkgs.zsh;
        packages = with pkgs; [
            tree
        ];
    };
}