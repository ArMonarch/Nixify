###################################################
# Noctalia Wayland desktop shell for NixOS,
# installed from its upstream flake input.
###################################################
{
  lib,
  pkgs,
  config,
  username,
  inputs',
  ...
}: let
  cfg = config.nixify.aspect.wayland.noctalia;
  toml = pkgs.formats.toml {};
in {
  options.nixify.aspect.wayland.noctalia = {
    package = lib.options.mkOption {
      type = lib.types.package;
      default = inputs'.noctalia.packages.default;
      defaultText = lib.options.literalExpression "inputs'.noctalia.packages.default";
      description = "the noctalia package to install";
    };

    settings = lib.options.mkOption {
      inherit (toml) type;
      default = {};
      description = "configuration for noctalia that will be written to all users {file} `$XDG_CONFIG_HOME/noctalia/config.toml`";
    };
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = [cfg.package];
    }

    # Default config: one auto-hiding bottom dock bar, taskbar in the middle,
    # clock at the end. Deliberately no top bar and no status widgets.
    {
      nixify.aspect.wayland.noctalia.settings = {
        # a bar, not the [dock] component: only bars host widgets
        bar.dock = {
          position = "bottom";
          thickness = 52;
          background_opacity = 0.88;
          radius = 18;
          margin_ends = 420; # the inset is what makes it dock-width
          margin_edge = 8; # floats it off the screen edge
          padding = 12;
          widget_spacing = 12;
          shadow = true;

          auto_hide = true;
          show_on_workspace_switch = true; # brief peek on workspace change
          reserve_space = false; # an auto-hiding dock holds no exclusive zone
          layer = "top";

          # smart_auto_hide = true; # alternative: hide only once windows appear

          center = ["dock_apps"];
          end = ["dock_clock"];
        };

        widget.dock_apps = {
          type = "taskbar";
          icon_scale = 1.4;
          item_spacing = 10;
          pinned = ["com.mitchellh.ghostty" "firefox-nightly" "dev.zed.Zed"];
          pinned_opacity = 0.55;
          show_active_indicator = true;
          show_window_title = false;
        };

        widget.dock_clock = {
          type = "clock";
          format = "{:%H:%M}";
          tooltip_format = "{:%A %d %B %Y}";
        };

        # the built-in [dock] cannot host a clock
        dock.enabled = false;
      };
    }

    {
      # A symlink is safe: noctalia treats config.toml as read-only and
      # persists GUI changes to `$XDG_STATE_HOME/noctalia/settings.toml`.
      hjem.users.${username}.xdg.config.files = {
        "noctalia/config.toml" = {
          type = "symlink";
          value = cfg.settings;
          generator = toml.generate "config.toml";
        };
      };
    }
  ];
}
