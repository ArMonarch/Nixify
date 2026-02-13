{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  cfg = config.nixify.aspect.programs.ghostty;
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
in {
  options.nixify.aspect.programs.ghostty = {
    enable = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Ghostty Terminal Emulator";
    };

    systemWide = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = "install ghostty terminal emulator system wide instead as user package";
    };

    package = lib.options.mkPackageOption pkgs "ghostty" {};

    font = lib.options.mkOption {
      type = lib.types.enum ["jetbrains" "jetbrains-mono" "iosevka" "iosevka-mono" "mononoki" "mononoki-mono"];
      default = "jetbrains";
      description = "font the ghostty will use by default";
    };

    settings = lib.options.mkOption {
      inherit (keyValue) type;
      default = {};
      description = "configuration for ghostty that will be written to all users {file} `$XDG_CONFIG_HOME/ghostty/config`";
    };
  };

  config = lib.modules.mkIf cfg.enable (
    lib.mkMerge [
      (
        lib.modules.mkIf (cfg.systemWide) {
          environment.corePackages = [cfg.package];
        }
      )

      (
        lib.modules.mkIf (!cfg.systemWide) {
          users.users.${username}.packages = [cfg.package];
        }
      )

      (lib.modules.mkIf (cfg.font == "jetbrains" || cfg.font == "jetbrains-mono") {
        fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];
      })

      (lib.modules.mkIf (cfg.font == "iosevka" || cfg.font == "iosevka-mono") {
        fonts.packages = [pkgs.nerd-fonts.iosevka];
      })

      (lib.modules.mkIf (cfg.font == "mononoki" || cfg.font == "mononoki-mono") {
        fonts.packages = [pkgs.nerd-fonts.mononoki];
      })

      # defines the default configuration for the ghostty terminal emulator
      {
        nixify.aspect.programs.ghostty.settings = lib.modules.mkMerge [
          {
            # Theme
            theme = "TokyoNight Night";

            # Window Padding
            window-padding-x = 0;
            window-padding-y = 0;
            window-padding-balance = true;
            window-padding-color = "extend";
            window-vsync = true;

            # working directory
            working-directory = "home";
            window-inherit-working-directory = true;

            # window property
            window-decoration = "none";
            window-theme = "system";
            window-save-state = "never";

            # shell integration features
            shell-integration-features = "no-cursor, title, ssh-terminfo, ssh-env";

            # Cursor Customization
            cursor-style = "block";
            cursor-style-blink = false;
            mouse-hide-while-typing = true;

            # window transparency customization
            background-opacity = 0.94;
            background-blur-radius = 20;

            # Resize Configuration
            resize-overlay = "always";
            resize-overlay-position = "bottom-right";

            # Key Bindings
            keybind = [
              "ctrl+shift+|=new_split:right"
              "ctrl+shift+-=new_split:down"

              "ctrl+shift+j=goto_split:bottom"
              "ctrl+shift+k=goto_split:top"
              "ctrl+shift+h=goto_split:left"
              "ctrl+shift+l=goto_split:right"

              "ctrl+shift+n=new_window"
              "ctrl+shift+t=new_tab"

              "ctrl+q=close_surface"
              "alt+g=toggle_window_decorations"

              "ctrl+shift+c=copy_to_clipboard"
              "ctrl+shift+v=paste_from_clipboard"
            ];
          }

          # Configure the font family for ghostty
          (lib.modules.mkIf (cfg.font == "jetbrains") {
            font-family = "JetbrainsMono Nerd Font";
            font-size = 12.5;
          })

          (lib.modules.mkIf (cfg.font == "jetbrains-mono") {
            font-family = "JetbrainsMono Nerd Font Mono";
            font-size = 12.5;
          })

          (lib.modules.mkIf (cfg.font == "iosevka") {
            font-family = "Iosevka Nerd Font";
            font-size = 13.5;
          })

          (lib.modules.mkIf (cfg.font == "iosevka-mono") {
            font-family = "Iosevka Nerd Font Mono";
            font-size = 13.5;
          })

          (lib.modules.mkIf (cfg.font == "mononoki") {
            font-family = "Mononoki Nerd Font";
            font-style = "Regular";
            font-size = 13.5;
          })

          (lib.modules.mkIf (cfg.font == "mononoki-mono") {
            font-family = "Mononoki Nerd Font Mono";
            font-style = "Regular";
            font-size = 13.5;
          })
        ];
      }

      {
        hjem.users.${username}.xdg.config.files = {
          "ghostty/config" = {
            type = "copy";
            value = cfg.settings;
            generator = keyValue.generate "config";
          };
        };
      }
    ]
  );
}
