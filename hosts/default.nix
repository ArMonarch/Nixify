{
  inputs,
  lib,
  nixify-lib,
  ...
}: let
  inherit (lib) concatLists singleton;
  inherit (nixify-lib) mkNixosSystem;

  # Specify root path for the modules. The concept is similar to modulesPath
  # that is found in nixpkgs
  modulePath = ../modules;

  aspectPaths = modulePath + /aspects; # the module that define an aspect of the confuguration
  coreModules = modulePath + /core; # the modules that configures based on the options
  options = modulePath + /options; # the module that provides the options for my system configuration

  mkModulesFor = host: {
    aspects ? [],
    extraModules ? [],
  }:
    concatLists [
      (singleton ./${host}/host.nix)
      (builtins.map (aspect: aspectPaths + /${aspect}) aspects)
      extraModules
      (singleton options)
      (singleton coreModules)
    ];
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
      modules = mkModulesFor "lunar" {
        aspects = ["boot-loader/grub"];
      };
    };
  };
}
