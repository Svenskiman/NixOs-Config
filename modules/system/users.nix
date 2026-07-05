{ pkgs, ... }:

{
  users.users.svenski = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  users.users.shrike = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtYOkzxdgWIBjhVF7ogd7JcAiFRR5pOtaez5Kq51ewC svenski@behemoth"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/iX0teBiasmebntG6BLxynDH2TnA+kaqsJw6KOH/ae root@behemoth"
    ];
  };
}
