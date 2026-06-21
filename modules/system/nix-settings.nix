{ ... }:

{
    nixpkgs.config.allowUnfree = true;
    
    # Needed for sublime text
    nixpkgs.config.permittedInsecurePackages = [
        "openssl-1.1.1w"
    ];
    nix.settings.experimental-features = ["nix-command" "flakes"];
}