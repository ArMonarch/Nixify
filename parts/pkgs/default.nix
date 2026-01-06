{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      noctalia-shell = pkgs.callPackage ./noctalia-shell/default.nix {};
    };
  };
}
