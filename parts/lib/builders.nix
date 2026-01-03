{
  lib,
  inputs,
  withSystem,
  ...
}: let
  inherit (lib) mkDefault;

  # shorthand alias to `lib.nixosSystem`
  mkSystem = lib.nixosSystem;
in {
  inherit mkSystem;

  mkNixosSystem = {
    hostname,
    username,
    modules,
    system,
    ...
  }:
    withSystem system ({
      self',
      inputs',
      ...
    }:
      mkSystem {
        inherit system;
        specialArgs = {
          inherit hostname username;
          inherit inputs self' inputs';
        };
        modules =
          [{nixpkgs.hostPlatform = mkDefault system;}]
          ++ modules;
      });
}
