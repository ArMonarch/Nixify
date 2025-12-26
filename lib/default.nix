{ pkgs, lib, ... }:
let
  inherit (lib.types)
    str
    submodule
    nullOr
    lines
    ;
  inherit (lib.options) mkEnableOption mkOption;
in
{
  fileTypeRelativeTo =
    { rootDir }:
    submodule ({
      enable = mkEnableOption "creation of this file" // {
        default = true;
        example = false;
      };

      text = mkOption {
        type = nullOr lines;
        default = null;
        description = "Text of the file.";
      };

      target = mkOption {
        type = str;
        default = rootDir;
        description = ''
          Path to target file relative to `${rootDir}`.
        '';
      };

      config = lib.mkMerge [ ];
    });
}
