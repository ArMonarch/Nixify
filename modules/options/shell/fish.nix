{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool enum listOf;
in {
  options.system.modules.shell.fish = {
    enable = mkOption {
      type = bool;
      default = true;
      example = false;
      description = "enable the fish shell";
    };

    features.integrations = mkOption {
      type = listOf (enum ["eza" "git"]);
      default = [];
      example = ["eza"];
      description = "sane default aliases for listed programs that should be added";
    };
  };
}
