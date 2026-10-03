{
  lib,
  clangStdenv,
  # The `raddebugger` flake input (master), so `nix flake update` bumps it.
  src,
  pkg-config,
  freetype,
  libx11,
  libxext,
  libxfixes,
  libxrandr,
  libGL,
  makeDesktopItem,
  copyDesktopItems,
}:
clangStdenv.mkDerivation {
  pname = "raddebugger";
  # No linux release tags yet; version from BUILD_VERSION_* in base_context_cracking.h.
  version = "0.9.30-unstable-${src.shortRev}";

  inherit src;

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    freetype
    libx11
    libxext
    libxfixes
    libxrandr
    libGL
  ];

  # build.sh owns its flags, and -D_FORTIFY_SOURCE trips on its many TUs.
  hardeningDisable = ["fortify"];

  # The fetched src has no .git, so build.sh skips its `git describe` stamp.
  env.NIX_CFLAGS_COMPILE = ''-DBUILD_GIT_HASH="${src.shortRev}"'';

  postPatch = ''
    patchShebangs build.sh
  '';

  buildPhase = ''
    runHook preBuild
    ./build.sh release raddbg radbin radlink
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin build/raddbg build/radbin build/radlink
    install -Dm644 data/logo.png $out/share/icons/hicolor/256x256/apps/raddbg.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "raddbg";
      desktopName = "RAD Debugger";
      exec = "raddbg";
      icon = "raddbg";
      categories = ["Development" "Debugger"];
    })
  ];

  meta = {
    description = "Native, user-mode, multi-process, graphical debugger (with radbin and radlink)";
    homepage = "https://github.com/EpicGamesExt/raddebugger";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
    mainProgram = "raddbg";
  };
}
