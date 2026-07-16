_:

{
  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "com.usebottles.bottles";
        origin = "flathub";
      }
      {
        appId = "com.github.tchx84.Flatseal";
        origin = "flathub";
      }
    ];
    overrides.settings = {
      # Give bottles access to proton and game files
      "com.usebottles.bottles".Context.filesystems = [
        "/mnt/games"
        "/mnt/games/SteamLibrary"
        "~/.steam"
        "~/.local/share/Steam"
      ];
    };
  };
}
