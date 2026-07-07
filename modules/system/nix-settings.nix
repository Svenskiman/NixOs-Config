_:

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
    problems.handlers.sublimetext4.broken = "warn";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
