{ pkgs, lib, ... }:
let
  inherit (lib.types)
    str
    submodule
    nullOr
    lines
    path
    ;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkDefault mkDerivedConfig;
in
{
  fileTypeRelativeTo =
    { rootDir }:
    submodule (
      { name, config, ... }:
      {
        options = {
          enable = mkEnableOption "creation of this file" // {
            default = true;
            example = false;
          };

          text = mkOption {
            type = nullOr lines;
            default = null;
            description = "Text of the file.";
          };

          relativeTo = mkOption {
            internal = true;
            type = path;
            readOnly = true;
            default = rootDir;
            description = "Path that symlinks are relative to.";
          };

          target = mkOption {
            type = str;
            apply = p: "${config.relativeTo}/${p}.txt";
            description = ''
              Path to target file relative to `${rootDir}`.
            '';
          };
        };

        config = lib.mkMerge [
          {
            target = mkDefault name;
          }
        ];
      }
    );
}
