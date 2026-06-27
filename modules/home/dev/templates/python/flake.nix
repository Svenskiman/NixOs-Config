{
    description = "Python development environment";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        devenv.url = "github:cachix/devenv";
        devenv.inputs.nixpkgs.follows = "nixpkgs";
        nixpkgs-python.url = "github:cachix/nixpkgs-python";
        nixpkgs-python.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, devenv, ... } @ inputs:
    let
        system = "x86_64-linux";
        pkgs   = nixpkgs.legacyPackages.${system};
    in
    
    {
        devShells.${system}.default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
                {
                    languages.python = {
                        enable = true;
                        version = "3.13";
                        uv.enable = true;
                    };

                    packages = with pkgs; [
                        openssl
                        libpq
                        zlib
                        libffi
                        gcc
                    ];

                    enterShell = ''
                        echo "Python $(python --version) ready"
                        echo "uv $(uv --version) ready"
                    '';
                }
            ];
        };
    };
}