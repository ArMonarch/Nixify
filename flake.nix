{
  # https://github.com/ArMonarch/Nixify
  description = "My vastly overengineered monorepo for everything NixOS";

  inputs = {
    # NixOS official source, using the nixos-25.11 branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # NixOS official source, using the nixos-unstable branch
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # defines system that this flake supports
    systems.url = "github:nix-systems/default-linux";

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # home-manager alternative
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # Systems for which attributes of perSystem will be built.
      systems = import inputs.systems;

      imports = [
        ./parts # Parts of the flake that are used to construct the final flake.
        ./hosts # entry point for nixos configurations for each defined hosts
      ];
    };
}
