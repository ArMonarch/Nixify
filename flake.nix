{
  # https://github.com/ArMonarch/Nixify
  description = "My vastly overengineered monorepo for everything NixOS";

  inputs = {
    # NixOS official source, using the nixos-26.05 branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # NixOS official source, using the nixos-unstable branch
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # defines system that this flake supports
    systems.url = "github:nix-systems/default-linux";

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # for wrapping programs with their configuration
    wrappers = {
      url = "github:lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my neovim with wrapped configuration.
    # NOTE: intentionally does NOT follow the system nixpkgs. On nixos-26.05
    # neovim-unwrapped pulls `replace` (lib.licenses.unfree) as a build input,
    # and nixvim builds its own pkgs without allowUnfree, so following our
    # nixpkgs breaks evaluation. Letting nixvim use its own pinned nixpkgs
    # (nixos-25.11, where this build works) avoids the failure.
    nixvim = {
      url = "github:ArMonarch/Nixvim";
    };

    # nixfetch: fetch util wirtten in odin lang
    nixfetch = {
      url = "github:ArMonarch/nixfetch";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };

    # home-manager alternative
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # firefox nightly builds
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # claude code latest
    claude-code = {
      url = "github:sadjow/claude-code-nix";
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
