{
  description = "ArMonarch's Nix Packages";

  inputs = {
    systems.url = "github:nix-systems/default-linux";
    # NixOS official package source, using the nixos-25.05 branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # wrappers: Nix library to create wrapped executables source
    wrappers = {
      url = "github:lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      systems,
      ...
    }:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      legacyPackages = forEachSystem (
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
