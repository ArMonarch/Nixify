{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum listOf nullOr str;
in {
  options.system.modules.programs.eza = {
    icons = mkOption {
      type = enum ["always" "auto" "automatic" "never"];
      default = "never";
      example = "auto";
      description = "Display icons next to file names (--icons argument).";
    };

    extraConfig = mkOption {
      type = listOf (nullOr str);
      default = [];
      example = [
        "--group-directories-first"
        "--header"
      ];
      description = "Extra command line options passed to eza.";
    };
  };
}
