{ pkgs, ... }:

{
    users.users.svenski = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        packages = with pkgs; [
            tree
        ];
    };
}