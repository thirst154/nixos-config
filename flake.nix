{
  description = "Tom's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    vicinae.url = "github:vicinaehq/vicinae";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    vicinae,
    ghostty,
    alejandra,
    helium,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              (import ./overlays/glaze-fix.nix)
            ];
          })
          ./hosts/thinkpad/default.nix
          home-manager.nixosModules.home-manager
          vicinae.nixosModules.default
          {
            environment.systemPackages = [alejandra.packages.${system}.default];
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.thirst = import ./modules/home/default.nix;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.sharedModules = [
              {home.enableNixpkgsReleaseCheck = false;}
              vicinae.homeManagerModules.default
            ];
          }
        ];
      };
    };
  };
}
