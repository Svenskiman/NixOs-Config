{ pkgs, ... }:

{
    users.users.svenski = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
        packages = with pkgs; [
            tree
        ];
    };
}