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
  # WireGuard / Teleport runtime tools invoked by the bundled wg-quick script
  wireguard-tools,
  iproute2,
  iptables,
  nftables,
  openresolv,
  procps,
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
    # The bundled scripts ship a `/bin/bash` shebang; point it at a real
    # bash executable (not just the package directory).
    substituteInPlace $out/lib/wifiman-desktop/wg-quick --replace-fail /bin/bash ${lib.getExe' bash "bash"}
    substituteInPlace $out/lib/wifiman-desktop/wg_report.sh --replace-fail /bin/bash ${lib.getExe' bash "bash"}
    substituteInPlace $out/lib/wifiman-desktop/wifiman-desktop.service --replace-fail /usr/lib/wifiman-desktop/wifiman-desktopd $out/lib/wifiman-desktop/wifiman-desktopd

    # The privileged daemon shells out to iw/ifconfig/iwconfig for scanning and
    # to the bundled wg-quick for the Teleport VPN, which in turn needs the
    # WireGuard userspace tooling on PATH (plus the bundled wireguard-go).
    makeWrapper $out/lib/wifiman-desktop/wifiman-desktopd $out/bin/wifiman-desktopd \
      --prefix PATH : ${
      lib.makeBinPath [
        iw
        net-tools
        wirelesstools
        wireguard-tools
        iproute2
        iptables
        nftables
        openresolv
        procps
      ]
    } \
      --prefix PATH : $out/lib/wifiman-desktop

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

  meta = {
    description = "Ubiquiti WiFiman Desktop — network scanning, device discovery and Teleport VPN client";
    homepage = "https://www.wifiman.com/desktop";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "wifiman-desktop";
  };
}
