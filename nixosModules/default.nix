{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.nixify;
  nixifyModule = lib.types.submoduleWith {
    description = "Nixify Module";
    class = "nixify";

    specialArgs = {
      inherit pkgs;
      inherit lib;
    }
    // cfg.extraSpecialArgs;

    modules = [
      (
        { ... }:
        {
          imports = import ./modules/modules.nix { };
        }
      )
    ];
  };
in
{
  options.nixify = {
    useUserPackage = mkEnableOption ''
      installation of user packages through the
      {option}`users.users.<name>.packages` option'';

    extraSpecialArgs = mkOption {
      type = types.attrs;
      default = { };
      example = lib.literalExpression "{ inherit nixify-overlay; }";
      description = ''
        Extra `specialArgs` passed to Nixify. This
        option can be used to pass additional arguments to all modules.
      '';
    };

    users = mkOption {
      type = types.attrsOf nixifyModule;
      default = { };
      description = ''
        Per-user Nixify configuration.
      '';
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (cfg.users != { }) {
      users.users = lib.mapAttrs (username: usercfg: {
        packages = lib.mkAfter usercfg.home.packages;
      }) cfg.users;
    })
  ];
}
