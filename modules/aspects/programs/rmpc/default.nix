{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  cfg = config.nixify.aspect.programs.rmpc;
in {
  options = {
    nixify.aspect.programs.rmpc = {
      configProfile = lib.options.mkOption {
        type = lib.types.enum ["default" "full" "minimal"];
        default = "default";
        description = "config profile name that rmpc uses";
      };

      themeProfile = lib.options.mkOption {
        type = lib.types.enum ["default" "full" "minimal"];
        default = "default";
        description = "theme profile name that rmpc uses";
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [rmpc];

    hjem.users.${username}.xdg.config.files = {
      # rmpc config file
      "rmpc/config.ron" = {
        type = "symlink";
        source = ./config/${cfg.configProfile}.ron;
      };
      # rmpc theme file
      "rmpc/themes/default.ron" = {
        type = "symlink";
        source = ./themes/${cfg.themeProfile}.ron;
      };
    };
  };
}
