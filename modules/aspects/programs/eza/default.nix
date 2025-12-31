{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
in {
  config = mkMerge [
    {
      environment.corePackages = [pkgs.eza];
    }
    (
      mkIf config.programs.fish.enable
      {
        programs.fish.shellAbbrs = {
          tree = "eza --tree";
        };

        programs.fish.shellAliases = let
          args =
            ["--icons=${config.system.modules.programs.eza.icons}"]
            ++ config.system.modules.programs.eza.extraConfig;
          eza = builtins.concatStringsSep " " (["eza"] ++ args);
        in {
          ls = "${eza}";
          ll = "${eza} -l";
          la = "${eza} -a";
          lt = "${eza} --tree --level=2";
        };
      }
    )
  ];
}
