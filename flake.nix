{
  description = "Tom's Nixos Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      # Add more hosts here later — just duplicate this block
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/thinkpad/default.nix
          home-manager.nixosModules.home-manager
          {environment.systemPackages = [alejandra.defaultPackage.${system}];}
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thirst = import ./modules/home/default.nix;
          }
        ];
      };
    };
  };
}
