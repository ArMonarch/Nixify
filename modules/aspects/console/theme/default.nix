{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.colorScheme != null) {
    console.colors = with config.colorScheme; [
      base00
      base08
      base0B
      base0A
      base0D
      base0E
      base0C
      base05
      base03
      base08
      base0B
      base0A
      base0D
      base0E
      base0C
      base07
    ];
  };
}
