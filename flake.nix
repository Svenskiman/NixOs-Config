{
  description = "Svenskis NixOS Config";
    
  inputs =  {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # Use my packages
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For configuring walker with home manager
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };	
  };

  outputs = {nixpkgs, home-manager, walker, ...}: {
    nixosConfigurations.beelzebub = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Load my stuff
      modules = [
        ./hosts/beelzebub/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.svenski = import ./modules/home/home.nix;
            backupFileExtension = "backup";
            sharedModules = [ walker.homeManagerModules.default ];
          };
        }
	    ];
    };
  };
}
