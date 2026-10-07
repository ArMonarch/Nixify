{inputs, ...}: {
  perSystem = {
    system,
    inputs',
    ...
  }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    _module.args.pkgs = pkgs;

    packages = {
      wifiman-desktop = pkgs.callPackage ./wifiman-desktop/default.nix {};
      raddebugger = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./raddbg/default.nix {src = inputs.raddebugger;};
      ladybird = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./ladybird/default.nix {src = inputs.ladybird;};
    };
  };
}
