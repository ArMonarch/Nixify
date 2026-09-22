###################################################
# Windows games via umu-launcher + Proton, no Steam
# client. umu ships Valve's Steam Linux Runtime, so
# Proton gets the container it expects.
#
# Usage: nvidia-offload gamemoderun umu-run game.exe
# Games outside $HOME need STEAM_COMPAT_MOUNTS.
###################################################
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixify.aspect.gaming;

  # `null` leaves PROTONPATH unset so umu fetches and self-updates the latest
  # UMU-Proton itself, the newest Proton without a rebuild.
  protonPath =
    if cfg.proton.source == "umu"
    then null
    else if cfg.proton.source == "ge"
    then "GE-Proton" # umu resolves this to the latest GE-Proton release
    else "${cfg.proton.package.steamcompattool}";

  # These must exist inside umu's FHS container; a layer resolved on the host
  # is not resolved for the game.
  containerPkgs = pkgs:
    lib.optional cfg.mangohud.enable pkgs.mangohud
    ++ lib.optional cfg.gamemode.enable pkgs.gamemode;
in {
  options.nixify.aspect.gaming = {
    package = lib.options.mkOption {
      type = lib.types.package;
      default = pkgs.umu-launcher.override {
        # `extraPkgs` is the 64-bit tree, `extraLibraries` the multilib list
        # so 32-bit titles get the same layers.
        extraPkgs = containerPkgs;
        extraLibraries = containerPkgs;

        extraProfile = lib.optionalString (protonPath != null) ''
          # A PROTONPATH from the caller still wins over the aspect's default.
          export PROTONPATH="''${PROTONPATH:-${protonPath}}"
        '';
      };
      defaultText = lib.literalExpression "pkgs.umu-launcher.override {...}";
      description = "umu-launcher package, wrapped so the container sees the overlay and optimisation tooling";
    };

    proton = {
      source = lib.options.mkOption {
        type = lib.types.enum ["umu" "ge" "pinned"];
        default = "umu";
        description = ''
          Which Proton build umu runs games under.

          `umu` leaves PROTONPATH unset so umu downloads and keeps the latest
          UMU-Proton current by itself, `ge` does the same for the latest
          GE-Proton, and `pinned` uses {option}`proton.package` from the store
          so the Proton version is fixed by the flake lock instead.
        '';
      };

      package = lib.options.mkPackageOption pkgs "proton-ge-bin" {};
    };

    gamemode.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = "run the gamemoded daemon and expose `gamemoderun` to games";
    };

    gamescope.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install the gamescope micro-compositor for upscaling and frame limiting";
    };

    mangohud.enable = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install the MangoHud performance overlay, usable with `MANGOHUD=1`";
    };
  };

  config = lib.mkMerge [
    {
      # 32-bit titles and DXVK; the gpu aspects only enable the 64-bit set
      hardware.graphics.enable32Bit = true;

      environment.systemPackages = [
        cfg.package
        pkgs.winetricks # poke a WINEPREFIX directly
        pkgs.protontricks # the same, for Proton-shaped prefixes
      ];
    }

    (lib.modules.mkIf cfg.mangohud.enable {
      environment.systemPackages = [pkgs.mangohud];
    })

    (lib.modules.mkIf cfg.gamemode.enable {
      programs.gamemode = {
        enable = true;
        # gamemoded cannot lower niceness without CAP_SYS_NICE
        enableRenice = true;
      };
    })

    (lib.modules.mkIf cfg.gamescope.enable {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
    })
  ];
}
