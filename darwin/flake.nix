{
  description = "Configuration for mac";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    configs.url = "path:../";
    nixpkgs.follows = "configs/nixpkgs";
  };

  outputs = inputs@{ self, flake-parts, home-manager, nix-darwin, nix-homebrew, configs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-darwin" "aarch64-darwin" ];

      flake = {
        darwinConfigurations."samson" = nix-darwin.lib.darwinSystem {
          modules = [
            ./samson.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "samson";
                autoMigrate = true;
              };
                
              environment.systemPackages = [
                configs.packages.aarch64-darwin.nvim
                configs.packages.aarch64-darwin.tmux
              ];
            }

            home-manager.darwinModules.home-manager
            {
              users.users.samson.home = "/Users/samson";
              home-manager.extraSpecialArgs = { inherit self; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.samson = ../home.nix;
            }
          ];
        };
      };
    };
}
