###################################################
# COSMIC Files file manager for NixOS
###################################################
{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  cfg = config.nixify.aspect.programs.cosmic-files;
in {
  options.nixify.aspect.programs.cosmic-files = {
    systemWide = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = "install cosmic-files system wide instead as user package";
    };

    package = lib.options.mkPackageOption pkgs "cosmic-files" {};
  };

  config = lib.mkMerge [
    (
      lib.modules.mkIf (cfg.systemWide) {
        environment.systemPackages = [cfg.package];
      }
    )

    (
      lib.modules.mkIf (!cfg.systemWide) {
        users.users.${username}.packages = [cfg.package];
      }
    )
  ];
}
