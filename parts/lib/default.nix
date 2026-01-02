{
  inputs,
  withSystem,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  # This defines the custom library and its functions.
  nixify-lib = rec {
    # System builders and similar functions.
    builder = import ./builders.nix {inherit lib inputs withSystem;};

    # also get some individual functions from the parent attributes so that its directly accessible through nixixy-lib
    inherit (builder) mkSystem mkNixosSystem;
  };
in {
  # set nixify-lib as args passed to every module
  _module.args.nixify-lib = nixify-lib;
}
