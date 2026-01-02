{
  lib,
  inputs,
  withSystem,
  ...
}: let
  # inherit self form inputs
  inherit (inputs) self;
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
      inputs',
      self',
      ...
    }:
      mkSystem {
        inherit system;
        specialArgs = {
          inherit hostname username;
          inherit inputs self inputs' self';
        };
        modules =
          [{nixpkgs.hostPlatform = mkDefault system;}]
          ++ modules;
      });
}
