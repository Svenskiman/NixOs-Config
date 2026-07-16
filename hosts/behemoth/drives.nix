{ pkgs, ... }:

let
  hyperionTailscaleIP = "100.75.168.106";
in

{
  programs.fuse.userAllowOther = true;
  environment.systemPackages = [ pkgs.sshfs ];
  boot.supportedFilesystems."fuse.sshfs" = true;

  programs.ssh.knownHosts = {
    hyperion = {
      hostNames = [ hyperionTailscaleIP ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC1vrrT4UsHH3OW4b02OvnOGViV5dkiPxKJ9yePIGejY";
    };
  };

  fileSystems = {
    "/mnt/2tb-ssd" = {
      device = "/dev/disk/by-uuid/2cc3d919-7a9a-4891-acd7-f7587cde6230";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "nofail"
      ];
    };

    "/mnt/games" = {
      device = "/dev/disk/by-uuid/ed67dd4a-9c51-49b2-bcf2-f8ccbc658fb8";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
      ];
    };

    "/mnt/4tb-hdd" = {
      device = "/dev/disk/by-uuid/ef6e43f2-34a5-46af-932f-c81c78bd1474";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };

    # Mount server drive
    "/mnt/hyperion" = {
      device = "shrike@${hyperionTailscaleIP}:/home/shrike";
      fsType = "fuse.sshfs";
      options = [
        "_netdev"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "allow_other"
        "default_permissions"
        "IdentityFile=/root/.ssh/id_ed25519_hyperion"
        "reconnect"
        "ServerAliveInterval=15"
        "idmap=user"
        "uid=1000"
        "gid=100"
      ];
    };
  };
}
