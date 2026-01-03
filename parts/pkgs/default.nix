{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages = {
      nixvim = pkgs.callPackage ./Nixvim/default.nix {inherit inputs pkgs lib;};
    };
  };
}
