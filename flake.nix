{
  description = "Nix Darwin Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    nvim-src.url = "path:./modules/nvim";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew, home-manager, flake-utils, ... }@inputs:
    let
    universalOutput = flake-utils.lib.eachDefaultSystem (system:
        let
        pkgs = nixpkgs.legacyPackages.${system};	
        in
        {
        packages = {
        nvim = inputs.nvim-src.packages.${system}.default;
        };
        }
        );

  systemConfigs = {
    darwinConfigurations."samson" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        ./configs/Darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "samson";
            };
          }

      home-manager.darwinModules.home-manager
      {
        users.users.samson.home = "/Users/samson";
        home-manager.extraSpecialArgs = { inherit self; };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.samson = ./home.nix;
      }
      ];
    };
    darwinPackages = self.darwinConfigurations."samson".pkgs;
  };
  in
    universalOutput // systemConfigs;
}
