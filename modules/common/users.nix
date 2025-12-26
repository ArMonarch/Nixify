# The common module that contains Nixify's per-user options.
{
  config,
  lib,
  nixify-lib,
  ...
}:
let
  inherit (lib.options) literalExpression mkEnableOption mkOption;
  inherit (lib.types)
    strMatching
    passwdEntry
    path
    package
    listOf
    ;
  inherit (nixify-lib) fileTypeRelativeTo;
  fileTypeRelativeTo' = lib.types.attrsWith {
    elemType = fileTypeRelativeTo;
    placeholder = "path";
  };

  cfg = config;
in
{
  _class = "nixify";

  options = {
    enable = mkEnableOption "home management for this user" // {
      default = true;
      example = false;
    };

    user = mkOption {
      type = strMatching "[a-zA-Z0-9_.][a-zA-Z0-9_.-]*";
      example = "frenzfries";
      description = "The owner of a given home directory.";
    };

    directory = mkOption {
      type = passwdEntry path;
      description = ''
        The home directory for the user, to which files configured in
        {option}`hjem.users.<username>.files` will be relative to by default.
      '';
    };

    files = mkOption {
      type = fileTypeRelativeTo';
      default = "";
      description = "Nixify managed files";
      example = {
        ".config/foo.txt".source = "Hello World";
      };
    };

    packages = mkOption {
      type = listOf package;
      default = [ ];
      example = literalExpression "[pkgs.hello]";
      description = "The set of packages to appear in the user environment.";
    };
  };
}
