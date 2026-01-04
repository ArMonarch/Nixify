{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) attrsOf nullOr str;
in {
  options.colorScheme = mkOption {
    type = nullOr (attrsOf str);
    default = null;
    example = {
      # Tokyo Night Moon theme
      base00 = "222436";
      base01 = "1e2030";
      base02 = "2d3f76";
      base03 = "3b4261";
      base04 = "636da6";
      base05 = "828bb8";
      base06 = "aeb4d1";
      base07 = "c8d3f5";
      base08 = "ff757f";
      base09 = "ffc777";
      base0A = "ffdf77";
      base0B = "c3e88d";
      base0C = "86e1fc";
      base0D = "82aaff";
      base0E = "fca7ea";
      base0F = "c53b53";
    };
    description = "A scheme following the base16 standard. This value must be attrs set of base16 standard";
  };
}
