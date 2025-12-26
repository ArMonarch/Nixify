{
  config,
  lib,
  options,
  pkgs,
  utils,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (lib.modules) importApply mkDefault;
  inherit (lib.types) submoduleWith;

  cfg = config.nixify;
  nixify-lib = import ../../lib/default.nix { inherit pkgs lib; };
  _class = "nixos";

  nixifySubmodule = submoduleWith {
    description = "Nixify Module for NixOS";
    class = "nixify";
    specialArgs = cfg.specialArgs // {
      inherit
        pkgs
        lib
        nixify-lib
        utils
        ;
      osConfig = config;
      osOptions = options;
    };
    modules = concatLists [
      [
        ../common/users.nix
        (
          { name, ... }:
          let
            user = config.users.users.${name};
          in
          {
            user = mkDefault user.name;
            directory = mkDefault user.home;
          }
        )
      ]
      # Evaluate additional modules under 'nixify.users.<username>' so that
      # module systems built on nixify are more ergonomic.
      cfg.extraModules
    ];
  };
in
{
  inherit _class;

  imports = [
    (importApply ../common/top-level.nix { inherit nixifySubmodule _class; })
  ];
}
