######################################################
# MPD, the music player daemon configuration for NixOS
######################################################
{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  cfg = config.nixify.aspect.services.mpd;
  mpdConfig = pkgs.writeText "mpd.conf" (''
      music_directory     "${cfg.musicDirectory}"
      playlist_directory  "${cfg.playlistDirectory}"
      db_file             "${cfg.dbFile}"
      state_file          "${cfg.dataDirectory}/state"
      sticker_file        "${cfg.dataDirectory}/sticker.sql"

      restore_paused      "yes"
      auto_update         "yes"

      audio_output {
        type              "pipewire"
        name              "PipeWire Sound Server"
      }

      default_permissions "read,add,player,control,admin"
    ''
    + lib.optionalString (cfg.network.listenAddress != "any") ''
      bind_to_address      "${cfg.network.listenAddress}"
    ''
    + lib.optionalString (cfg.network.port != 6600) ''
      port                  "${builtins.toString cfg.network.port}"
    '');
in {
  options.nixify.aspect.services.mpd = {
    package = lib.options.mkPackageOption pkgs "mpd" {};

    musicDirectory = lib.options.mkOption {
      type = lib.types.either lib.types.path lib.types.str;
      default = "/home/${username}/music";
      apply = builtins.toString; # Prevent copies to Nix store.
      description = "The directory where mpd reads music from.";
    };

    dataDirectory = lib.options.mkOption {
      type = lib.types.either lib.types.path lib.types.str;
      default = "/home/${username}/.local/state/mpd";
      apply = builtins.toString; # Prevent copies to Nix store.
      description = "The directory where MPD stores its state, tag cache, playlists etc.";
    };

    dbFile = lib.options.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "${cfg.dataDirectory}/tag_cache";
      apply = builtins.toString; # Prevent copies to Nix store.
    };

    playlistDirectory = lib.options.mkOption {
      type = lib.types.either lib.types.path lib.types.str;
      default = "${cfg.dataDirectory}/playlist";
      apply = builtins.toString; # Prevent copies to Nix store.
      description = "The directory where mpd stores playlists.";
    };

    network = {
      # FIX: startWhenNeeded doesn't work for ip address but
      # works for local unix sockets.
      startWhenNeeded = lib.options.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable systemd socket activation.";
      };

      listenAddress = lib.options.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address for the daemon to listen on.";
      };

      port = lib.options.mkOption {
        type = lib.types.port;
        default = 6600;
        description = "The TCP port on which the the daemon will listen.";
      };
    };
  };

  config = {
    systemd.user = {
      services.mpd = {
        name = "mpd.service";

        unitConfig = lib.modules.mkMerge [
          {
            Description = "MPD, The Music Player Daemon";
            After = ["network.target" "sound.target"];
          }
          (lib.modules.mkIf (cfg.network.startWhenNeeded) {
            Requires = ["mpd.socket"];
            After = ["mpd.socket"];
          })
        ];

        serviceConfig = {
          ExecStartPre = ''${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/mkdir -p '${cfg.dataDirectory}' '${cfg.playlistDirectory}'"'';
          ExecStart = "${cfg.package}/bin/mpd --no-daemon ${mpdConfig}";
          Type = "notify";
        };

        wantedBy = lib.modules.mkIf (!cfg.network.startWhenNeeded) ["default.target"];
      };

      sockets.mpd = lib.modules.mkIf (cfg.network.startWhenNeeded) {
        name = "mpd.socket";

        unitConfig = {
          Description = "MPD, Music Player Daemon Socket";
        };

        socketConfig = {
          ListenStream = let
            tcpListen =
              if cfg.network.listenAddress == "any"
              then toString cfg.network.port
              else "${cfg.network.listenAddress}:${builtins.toString cfg.network.port}";
          in [
            tcpListen
            "%t/mpd/socket"
          ];
          Backlog = 5;
          KeepAlive = true;
        };

        wantedBy = ["sockets.target"];
      };
    };

    environment.variables = {
      MPD_HOST = "$XDG_RUNTIME_DIR/mpd/socket";
      MPD_PORT = "${builtins.toString cfg.network.port}";
    };

    environment.corePackages = with pkgs; [mpc];
  };
}
