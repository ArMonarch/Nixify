{
  lib,
  autoPatchelfHook,
  bash,
  dpkg,
  fetchurl,
  glibc,
  libayatana-appindicator,
  makeWrapper,
  stdenv,
  stdenvNoCC,
  webkitgtk_4_1,
  desktop-file-utils,
  iw,
  net-tools,
  wirelesstools,
}:
stdenvNoCC.mkDerivation {
  pname = "wifiman-desktop";
  version = "1.2.8";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then
      fetchurl {
        url = "https://desktop.wifiman.com/wifiman-desktop-1.2.8-amd64.deb";
        hash = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
      }
    else throw "Unsupported System: ${stdenv.hostPlatform.system}";

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    glibc
    desktop-file-utils
    webkitgtk_4_1
    libayatana-appindicator
    iw
    net-tools
    wirelesstools
  ];

  phases = ["unpackPhase" "installPhase" "fixupPhase"];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $out
    dpkg-deb -x $src wifiman
    mv wifiman/usr/* $out
    rm -rf wifiman
    runHook postUnpack
  '';

  installPhase = ''
    substituteInPlace $out/lib/wifiman-desktop/wg-quick --replace-fail /bin/bash ${bash}
    substituteInPlace $out/lib/wifiman-desktop/wg_report.sh --replace-fail /bin/bash ${bash}
    substituteInPlace $out/lib/wifiman-desktop/wifiman-desktop.service --replace-fail /usr/lib/wifiman-desktop/wifiman-desktopd $out/lib/wifiman-desktop/wifiman-desktopd

    makeWrapper $out/lib/wifiman-desktop/wifiman-desktopd $out/bin/wifiman-desktopd \
      --prefix PATH : ${
      lib.makeBinPath [
        iw
        net-tools
        wirelesstools
      ]
    }

    wrapProgram $out/bin/wifiman-desktop \
      --prefix PATH : ${
      lib.makeBinPath [
        desktop-file-utils
      ]
    } \
      --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libayatana-appindicator
      ]
    }
  '';
}
