{
  description = "Build environment for Ladybird via ./Meta/ladybird.py";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # defines system that this flake supports
    systems.url = "github:nix-systems/default-linux";

    # powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {
        pkgs,
        lib,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {inherit system;};

        # An FHS env, not a plain shell: vcpkg strips absolute rpaths from what it
        # builds, so its tools and Ladybird must find libs in /usr/lib like on a
        # distro. vcpkg fetches and builds every dependency except Qt.
        packages.default = pkgs.buildFHSEnv {
          name = "ladybird";

          # headers and .pc files land in /usr/include and /usr/lib/pkgconfig
          extraOutputsToInstall = ["dev"];

          # upstream's apt list in Documentation/BuildInstructionsLadybird.md,
          # plus the build-essential base a distro would already have.
          # Clang 21: master wants a recent clang, and Qt >= 6.10.
          targetPkgs = pkgs:
            with pkgs; [
              llvmPackages_21.clang
              llvmPackages_21.lld # ld.lld on PATH: use_linker.cmake picks it for Lagom
              gnumake
              gnupatch
              gnused
              gawk
              gnugrep
              findutils
              diffutils
              which
              file
              perl
              gnum4
              bzip2
              gzip
              xz

              autoconf
              autoconf-archive
              automake
              libtool
              ccache
              cmake
              ninja
              nasm
              pkg-config
              python3
              git
              curl
              gnutar
              unzip
              zip
              glslang
              cargo
              rustc

              libdrm
              libGL
              libpulseaudio
              ncurses
              liberation_ttf
              libxkbcommon # XKB, needed by Qt6GuiPrivate
              glib # gio-2.0 for UI/Qt
              # glib.pc Requires.private; FHS has no propagated inputs
              libsysprof-capture
              pcre2
              libffi
              util-linuxMinimal
              libselinux
              libsepol
              vulkan-headers
              vulkan-loader

              qt6.qtbase
              qt6.qtpositioning
              qt6.qttools
              qt6.qtwayland
            ];

          # Qt's cmake files resolve their prefix to /usr, but the FHS rootfs only
          # maps bin/lib/share/include, dropping Qt's other top-level dirs.
          extraBuildCommands = ''
            ln -s ${pkgs.qt6.qtbase}/mkspecs $out/usr/mkspecs
            mkdir -p $out/usr/metatypes $out/usr/modules
            for q in ${toString (with pkgs.qt6; [qtbase qtpositioning qttools qtwayland])}; do
              for d in metatypes modules; do
                if [ -d "$q/$d" ]; then ln -sf "$q/$d"/* $out/usr/$d/; fi
              done
            done
          '';

          profile = ''
            # vcpkg's prebuilt cmake and ninja are not NixOS binaries; use ours.
            export VCPKG_FORCE_SYSTEM_BINARIES=1

            # No wrapQtApps on a local build, so Ladybird finds the wayland plugin here.
            export QT_PLUGIN_PATH=/usr/lib/qt-6/plugins

            # niri gets Qt's generic theme, which ignores the portal's color-scheme;
            # the gnome theme follows it, so Ladybird tracks system dark mode.
            export QT_QPA_PLATFORMTHEME=gnome
          '';

          # With arguments it runs them inside the env (the desktop entry);
          # without, it opens an interactive fish.
          runScript = pkgs.writeShellScript "ladybird-run" ''
            if [ "$#" -gt 0 ]; then
              exec "$@"
            fi

            echo "Initialized Ladybird Development Environment (FHS)"
            echo "  ├── $(clang --version | head -n1)"
            echo "  └── $(cmake --version | head -n1)"
            exec ${lib.getExe pkgs.fish} -C 'source ${./nix/prompt.fish}'
          '';
        };
      };
    };
}
