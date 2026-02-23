{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixify.aspect.programs.fish;
  eza_args = "--icons=auto --header --group-directories-first";
in {
  options = {
    nixify.aspect.programs.fish = {
      integrations = lib.options.mkOption {
        type = lib.types.listOf (lib.types.enum ["eza" "git"]);
        default = ["eza" "git"];
        description = "enable integrations of programs `eza | git` for fish";
      };
    };
  };

  config = {
    programs.fish = {
      enable = true;
      package = pkgs.fish;

      shellAbbrs = lib.modules.mkMerge [
        (lib.modules.mkIf (builtins.elem "git" cfg.integrations) {
          gb = "git branch";
          gdf = "git diff";
          gp = "git pull";
          gP = "git Push";
          gs = "git status";
        })

        (lib.modules.mkIf (builtins.elem "eza" cfg.integrations) {
          tree = "eza --tree ${eza_args}";
        })
      ];

      shellAliases = lib.modules.mkMerge [
        (lib.modules.mkIf
          (builtins.elem "eza" cfg.integrations)
          {
            glg = "git log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %C(green)(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit";
          })

        (lib.modules.mkIf (builtins.elem "eza" cfg.integrations) {
          ls = "eza ${eza_args}";
          ll = "eza -l ${eza_args}";
          la = "eza -a ${eza_args}";
          lt = "eza --tree --level=2 ${eza_args}";
        })
      ];
    };

    environment.systemPackages =
      []
      ++ lib.optional (builtins.elem "eza" cfg.integrations) pkgs.eza
      ++ lib.optional (builtins.elem "git" cfg.integrations) pkgs.git;
  };
}
