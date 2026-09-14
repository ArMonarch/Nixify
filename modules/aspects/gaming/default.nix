###################################################
# Windows games on Linux via umu-launcher + Proton,
# with no Steam client installed.
#
# umu-launcher ships Valve's Steam Linux Runtime
# (pressure-vessel) and Steam Runtime Tools, so Proton
# gets the container it expects without Steam itself.
# nixpkgs' `umu-launcher` is `steam.buildRuntimeEnv`
# wrapping `umu-launcher-unwrapped`, i.e. an FHS env
# only -- it pulls in no Steam client.
#
# Usage:
#   umu-run /path/to/game.exe
#   WINEPREFIX=~/Games/umu/witcher3 GAMEID=umu-499450 umu-run setup.exe
#
# On this host the dGPU is PRIME-offload, so games want:
#   nvidia-offload gamemoderun umu-run game.exe
#
# Games living outside $HOME are not visible inside the
# runtime container; bind them in explicitly with
#   STEAM_COMPAT_MOUNTS=/mnt/games
###################################################
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixify.aspect.gaming;

  # Where umu should look for Proton. `null` leaves PROTONPATH unset, which
  # makes umu fetch and self-update the latest UMU-Proton into
  # `$XDG_DATA_HOME/umu` on first run -- the newest Proton without a rebuild.
  protonPath =
    if cfg.proton.source == "umu"
    then null
    else if cfg.proton.source == "ge"
    then "GE-Proton" # umu resolves this to the latest GE-Proton release
    else "${cfg.proton.package.steamcompattool}";

  # These have to exist *inside* umu's FHS container, not merely in the user
  # profile: the launcher execs the game from within it, so an LD_PRELOAD or
  # Vulkan layer resolved on the host is not resolved for the game.
  containerPkgs = pkgs:
    lib.optional cfg.mangohud.enable pkgs.mangohud
    ++ lib.optional cfg.gamemode.enable pkgs.gamemode;
in {
  options.nixify.aspect.gaming = {
    package = lib.options.mkOption {
      type = lib.types.package;
      default = pkgs.umu-launcher.override {
        # `extraPkgs` populates the container's 64-bit tree (binaries, Vulkan
        # layer manifests); `extraLibraries` is the multilib list, so 32-bit
        # titles get the same layers.
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
      # 32-bit titles and DXVK need the 32-bit driver set at
      # /run/opengl-driver-32; the gpu aspects only enable the 64-bit one.
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
