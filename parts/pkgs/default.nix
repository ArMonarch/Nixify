{inputs, ...}: {
  perSystem = {system, ...}: let
    # Build the flake's own packages against a nixpkgs that permits unfree
    # licenses (wifiman-desktop is proprietary). This mirrors the hosts'
    # `nixpkgs` aspect, which also sets allowUnfree, so packages consumed via
    # `self'.packages` evaluate consistently in both contexts.
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    _module.args.pkgs = pkgs;

    packages = {
      noctalia-shell = pkgs.callPackage ./noctalia-shell/default.nix {};
      wifiman-desktop = pkgs.callPackage ./wifiman-desktop/default.nix {};
    };
  };
}
