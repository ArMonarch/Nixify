###################################################
# Btop resource monitor for NixOS, themed from
# the host's base16 colorScheme
###################################################
{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;

  # Gradients run green, yellow, red so a meter reads hotter as it fills.
  theme = with config.colorScheme; ''
    theme[main_bg]="#${base00}"
    theme[main_fg]="#${base05}"
    theme[title]="#${base06}"
    theme[hi_fg]="#${base0D}"
    theme[selected_bg]="#${base02}"
    theme[selected_fg]="#${base0D}"
    theme[inactive_fg]="#${base03}"
    theme[graph_text]="#${base06}"
    theme[meter_bg]="#${base02}"
    theme[proc_misc]="#${base0C}"
    theme[cpu_box]="#${base0E}"
    theme[mem_box]="#${base0B}"
    theme[net_box]="#${base0C}"
    theme[proc_box]="#${base0D}"
    theme[div_line]="#${base02}"
    theme[temp_start]="#${base0B}"
    theme[temp_mid]="#${base0A}"
    theme[temp_end]="#${base08}"
    theme[cpu_start]="#${base0B}"
    theme[cpu_mid]="#${base0A}"
    theme[cpu_end]="#${base08}"
    theme[free_start]="#${base0B}"
    theme[free_mid]="#${base0C}"
    theme[free_end]="#${base0D}"
    theme[cached_start]="#${base0C}"
    theme[cached_mid]="#${base0D}"
    theme[cached_end]="#${base0E}"
    theme[available_start]="#${base0A}"
    theme[available_mid]="#${base09}"
    theme[available_end]="#${base08}"
    theme[used_start]="#${base0B}"
    theme[used_mid]="#${base0A}"
    theme[used_end]="#${base08}"
    theme[download_start]="#${base0C}"
    theme[download_mid]="#${base0D}"
    theme[download_end]="#${base0E}"
    theme[upload_start]="#${base0B}"
    theme[upload_mid]="#${base0A}"
    theme[upload_end]="#${base09}"
    theme[process_start]="#${base0B}"
    theme[process_mid]="#${base0A}"
    theme[process_end]="#${base08}"
  '';
in {
  config = mkMerge [
    {
      environment.systemPackages = [pkgs.btop];
    }

    # Btop owns btop.conf and rewrites it on exit, so pick "nixify" once in
    # Options → Color theme; the theme file itself follows every rebuild.
    (mkIf (config.colorScheme != null) {
      hjem.users.${username}.xdg.config.files."btop/themes/nixify.theme" = {
        type = "symlink";
        source = pkgs.writeText "nixify.theme" theme;
      };
    })
  ];
}
