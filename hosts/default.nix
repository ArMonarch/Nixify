{
  inputs,
  lib,
  nixify-lib,
  ...
}: let
  inherit (lib) concatLists flatten singleton;
  inherit (nixify-lib) mkNixosSystem;

  mkModulesFor = host: {
    aspects ? [],
    extraModules ? [],
  }:
    flatten (
      concatLists [
        (singleton ./${host}/host.nix)
        extraModules
      ]
    );
in {
  flake.nixosConfigurations = {
    base = mkNixosSystem {
      hostname = "base";
      username = "frenzfries";
      system = "x86_64-linux";
      inherit inputs;
      modules = mkModulesFor "base" {};
    };

    lunar = mkNixosSystem {
      hostname = "lunar";
      username = "frenzfries";
      system = "x86_64-linux";
      inherit inputs;
      modules = mkModulesFor "lunar" {};
    };
  };
}
