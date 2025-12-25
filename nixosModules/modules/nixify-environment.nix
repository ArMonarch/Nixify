{ config, lib, ... }:
let
  cfg = config.home;
in
{
  options = {
    home.username = lib.mkOption {
      type = lib.types.str;
      defaultText = lib.literalExpression ''
        "$USER"   for state version < 20.09,
        undefined for state version ≥ 20.09
      '';
      example = "jane.doe";
      description = "The user's username.";
    };

    home.homeDirectory = lib.mkOption {
      type = lib.types.path;
      defaultText = lib.literalExpression ''
        "$HOME"   for state version < 20.09,
        undefined for state version ≥ 20.09
      '';
      apply = toString;
      example = "/home/jane.doe";
      description = "The user's home directory. Must be an absolute path.";
    };

    home.packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "The set of packages to appear in the user environment.";
    };
  };
}
