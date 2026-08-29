###################################################
# Noctalia Wayland desktop shell for NixOS
#
# Installs noctalia from its upstream flake input
# (github:noctalia-dev/noctalia), which pins the build
# and carries its own runtime deps, and renders
# `$XDG_CONFIG_HOME/noctalia/config.toml` from nix.
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

    # defines the default configuration for the noctalia desktop shell.
    #
    # A single bottom "dock" bar that auto-hides and carries the taskbar in the
    # middle with the clock at the end. There is deliberately no top bar, so
    # none of the usual status widgets (tray, network, battery, session, ...)
    # are placed anywhere.
    {
      nixify.aspect.wayland.noctalia.settings = {
        # A bar, not the [dock] component: only bars host widgets, so only a bar
        # can put a clock next to the app icons.
        bar.dock = {
          position = "bottom";
          thickness = 52;
          background_opacity = 0.88;
          radius = 18;
          margin_ends = 420; # inset from both ends — this is what makes it dock-width
          margin_edge = 8; # lifts it off the screen edge so it floats
          padding = 12;
          widget_spacing = 12;
          shadow = true;

          auto_hide = true; # slides out when the pointer leaves; reveals on edge approach
          show_on_workspace_switch = true; # brief peek when the active workspace changes
          reserve_space = false; # an auto-hiding dock shouldn't hold an exclusive zone
          layer = "top";

          # smart_auto_hide = true; # alternative: visible on empty workspaces, hidden once windows appear

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

        # The built-in [dock] stays off — it auto-hides but cannot host a clock.
        dock.enabled = false;
      };
    }

    {
      # a plain symlink is safe here: noctalia treats config.toml as read-only
      # and persists anything changed from its settings GUI to
      # `$XDG_STATE_HOME/noctalia/settings.toml` instead.
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
