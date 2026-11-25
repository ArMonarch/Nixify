###################################################
# nix-ld: lets prebuilt, non-Nix binaries (downloaded tools, games, SDL
# apps, Electron apps) find common shared libraries.
# NixOS always adds its base set (zlib, zstd, openssl, curl, libstdc++, ...).
###################################################
{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Old binaries that link libcrypt.so.1.
      libxcrypt-legacy

      # Graphics: OpenGL/EGL, DRM/GBM, VA-API.
      libGL
      libdrm
      libgbm
      libva # VA-API hardware video decode/encode

      # Windowing: Wayland.
      wayland
      libxkbcommon

      # Windowing: X11, the set RAD Debugger links (see parts/pkgs/raddbg).
      libx11
      libxext
      libxfixes
      libxrandr

      # SDL3.
      sdl3
      sdl3-image
      sdl3-ttf

      # Audio: PipeWire client (SDL3 and others pick it as their backend).
      pipewire

      # Text and fonts.
      fontconfig
      freetype
      harfbuzz

      # GTK/Electron runtime.
      glib
      gtk3
      cairo
      pango
      gdk-pixbuf
      atk
      nss
      nspr
      dbus
      cups
      expat

      # Misc runtime libraries.
      icu
      ncurses
      libusb1
    ];
  };
}
