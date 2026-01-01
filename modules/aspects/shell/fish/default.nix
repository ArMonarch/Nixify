{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib) optional;
  eza_args = "--icons=auto --header --group-directories-first";
in {
  config = mkIf config.system.modules.shell.fish.enable {
    programs.fish.enable = true;
    programs.fish.package = pkgs.fish;

    environment.corePackages =
      []
      ++ optional (builtins.elem "git" config.system.modules.shell.fish.features.integrations) pkgs.git
      ++ optional (builtins.elem "eza" config.system.modules.shell.fish.features.integrations) pkgs.eza;

    programs.fish.shellAbbrs = mkMerge [
      (
        mkIf (builtins.elem "git" config.system.modules.shell.fish.features.integrations) {
          gb = "git branch";
          gdf = "git diff";
          gp = "git pull";
          gP = "git Push";
          gs = "git status";
        }
      )
      (
        mkIf (builtins.elem "eza" config.system.modules.shell.fish.features.integrations) {
          tree = "eza --tree ${eza_args}";
        }
      )
    ];

    programs.fish.shellAliases = mkMerge [
      (
        mkIf (builtins.elem "git" config.system.modules.shell.fish.features.integrations) {
          glg = "git log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %C(green)(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit";
        }
      )
      (
        mkIf (builtins.elem "eza" config.system.modules.shell.fish.features.integrations) {
          ls = "eza ${eza_args}";
          ll = "eza -l ${eza_args}";
          la = "eza -a ${eza_args}";
          lt = "eza --tree --level=2 ${eza_args}";
        }
      )
    ];
  };
}
