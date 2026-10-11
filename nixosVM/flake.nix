{
  description = "Configuration for nixosVM";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    configs.url = "path:../";
    nixpkgs.follows = "configs/nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, configs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      flake.nixosConfigurations = {
        nixosVM = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixosVM.nix
            ../../configuration.nix
          ];

          environment.systemPackages = [
            configs.packages.aarch64-linux.nvim
            configs.packages.aarch64-linux.tmux
          ];
        };
      };
    };
}
