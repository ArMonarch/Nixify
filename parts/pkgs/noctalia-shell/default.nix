{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  qt6,
  quickshell,
  # runtime deps
  cliphist,
  ddcutil,
  imagemagick,
  matugen,
  wget,
  wlsunset,
  # optional flag
  version ? "v3.8.2",
  ...
}: let
  runtimeDeps = [
    cliphist
    ddcutil
    imagemagick
    matugen
    wget
    wlsunset
  ];
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "noctalia-shell";
    inherit version;

    src = fetchFromGitHub {
      owner = "noctalia-dev";
      repo = "noctalia-shell";
      tag = finalAttrs.version;
      hash = "sha256-ZjtdQbVPHJeWP8VHWZmSwPwD6fC7Dqmknx1KErzfDks=";
    };

    outputs = ["out"];

    nativeBuildInputs = [qt6.wrapQtAppsHook];
    buildInputs = [qt6.qtbase qt6.qtmultimedia];
    dontWrapQtApps = true;

    installPhase = ''
      mkdir -p $out/share/noctalia-shell $out/bin
      cp -r . $out/share/noctalia-shell
      ln -s ${quickshell}/bin/qs $out/bin/noctalia-shell
    '';

    preFixup = ''
      wrapQtApp "$out/bin/noctalia-shell" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --add-flags "-p $out/share/noctalia-shell"
    '';

    meta = {
      description = "A sleek and minimal desktop shell thoughtfully crafted for Wayland, built with Quickshell.";
      homepage = "https://github.com/noctalia-dev/noctalia-shell";
      license = lib.licenses.mit;
      mainProgram = "noctalia-shell";
    };
  })
