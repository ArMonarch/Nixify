{
  description = "ArMonarch's Nix Packages";

  inputs = {
    # NixOS official package source, using the nixos-unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    # wrappers: Nix library to create wrapped executables source
    wrappers = {
      url = "github:lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      defaultSystems = import systems;
      forEachSystem = nixpkgs.lib.genAttrs defaultSystems;
    in
    {
      packages = forEachSystem (
        system:
        let
          lib = nixpkgs.lib;
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./packages/default.nix {
          inherit lib;
          inherit pkgs;
        }
      );
    };
}
