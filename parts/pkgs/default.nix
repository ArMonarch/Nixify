{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      noctalia-shell = pkgs.callPackage ./noctalia-shell/default.nix {};
      wifiman-desktop = pkgs.callPackage ./wifiman-desktop/default.nix {};
    };
  };
}
