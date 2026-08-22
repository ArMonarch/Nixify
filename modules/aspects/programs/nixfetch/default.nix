#########################################
# Nixfetch system info tool configuration
#########################################
{
  lib,
  config,
  inputs',
  ...
}: let
  cfg = config.nixify.aspect.programs.nixfetch;
in {
  options = {
    nixify.aspect.programs.nixfetch.enabled = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install nixfetch. other aspects read this to decide whether to run it, e.g. ghostty runs it before handing off to the shell";
    };
  };

  config = lib.modules.mkIf cfg.enabled {
    environment.systemPackages = [
      inputs'.nixfetch.packages.default
    ];

    environment.variables = {
      NIXFETCH_IMAGE = "/home/frenzfries/Project/Nixify/modules/aspects/programs/nixfetch/alice_glasses.png";
    };
  };
}
