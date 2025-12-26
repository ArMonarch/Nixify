{ nixifySubmodule, _class }:
{
  lib,
  config,
  ...
}:
let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.options) literalExpression mkOption;
  inherit (lib.types)
    attrs
    attrsOf
    listOf
    raw
    ;

  cfg = config.nixify;
  enabledUsers = filterAttrs (_: usercfg: usercfg.enable) cfg.users;
in
{
  inherit _class;

  options.nixify = {
    users = mkOption {
      type = attrsOf nixifySubmodule;
      default = { };
      description = "Nixify managed user configurations.";
    };

    specialArgs = mkOption {
      type = attrs;
      default = { };
      example = literalExpression "{ inherit inputs; }";
      description = ''
        Additional `specialArgs` are passed to nixify, allowing extra arguments
        to be passed down to to all imported modules.
      '';
    };

    extraModules = mkOption {
      type = listOf raw;
      default = [ ];
      description = ''
        Additional modules to be evaluated as a part of the users module
        inside {option}`config.nixify.users.<username>`. This can be used to
        extend each user configuration with additional options.
      '';
    };
  };

  config = {
    users.users = mapAttrs (_: usercfg: { inherit (usercfg) packages; }) enabledUsers;
  };
}
