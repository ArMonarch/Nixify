# Ladybird local build

## Setup

```fish
git clone https://github.com/LadybirdBrowser/ladybird ~/Project/ladybird
cd ~/Project/ladybird
cp -r ~/Project/Nixify/dev/ladybird/{flake.nix,flake.lock,nix} .   # or restore from the reference files below
git add -N flake.nix nix/
nix build --profile ~/.local/state/nix/profiles/ladybird .   # FHS env + GC root
git add -N flake.lock
~/.local/state/nix/profiles/ladybird/bin/ladybird
./Meta/ladybird.py run ladybird --disable-sandbox
```

## Desktop entry

```fish
mkdir -p ~/.local/share/applications ~/.local/share/icons/hicolor/scalable/apps
cp ~/Project/ladybird/nix/org.ladybird.Ladybird.desktop ~/.local/share/applications/
cp ~/Project/ladybird/Meta/CMake/freedesktop/org.ladybird.Ladybird.svg ~/.local/share/icons/hicolor/scalable/apps/
```

## Update

```fish
cd ~/Project/ladybird
git pull
nix build --profile ~/.local/state/nix/profiles/ladybird .
~/.local/state/nix/profiles/ladybird/bin/ladybird
./Meta/ladybird.py build      # after `nix flake update`: ./Meta/ladybird.py rebuild
```

## Reset

```fish
rm -f ~/.local/state/nix/profiles/ladybird ~/.local/state/nix/profiles/ladybird-*-link
rm -rf ~/Project/ladybird/Build   # vcpkg downloads, buildtrees and binary cache live here
```

## Check GC root

```fish
nix-store --gc --print-roots | grep ladybird
```

## Reference files

### `flake.nix`

```nix
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
```

### `nix/prompt.fish`

```fish
if not functions -q __nix_upstream_prompt
  if functions -q fish_prompt
    functions --copy fish_prompt __nix_upstream_prompt
  else
    function __nix_upstream_prompt
      printf "%s> " (prompt_pwd)
    end
  end
end

function fish_prompt
  set_color -o blue
  printf '(nix) '
  set_color normal
  __nix_upstream_prompt
end
```

### `nix/org.ladybird.Ladybird.desktop`

```ini
[Desktop Entry]
Name=Ladybird
GenericName=Web Browser
Exec=/home/frenzfries/.local/state/nix/profiles/ladybird/bin/ladybird /home/frenzfries/Project/ladybird/Build/release/bin/Ladybird --disable-sandbox %U
Icon=org.ladybird.Ladybird
Type=Application
Categories=Network;WebBrowser;
StartupNotify=false
MimeType=text/html;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
Actions=new-window;

[Desktop Action new-window]
Name=New Window
Exec=/home/frenzfries/.local/state/nix/profiles/ladybird/bin/ladybird /home/frenzfries/Project/ladybird/Build/release/bin/Ladybird --disable-sandbox --new-window
```
