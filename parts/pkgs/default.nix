{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    _module.args.pkgs = pkgs;

    packages = {
      wifiman-desktop = pkgs.callPackage ./wifiman-desktop/default.nix {};
      raddebugger = pkgs.callPackage ./raddbg/default.nix {src = inputs.raddebugger;};
    };
  };
}
