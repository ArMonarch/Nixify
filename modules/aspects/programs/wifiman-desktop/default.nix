###################################################
# Ubiquiti WiFiman Desktop for NixOS
#
# Installs the WiFiman Desktop GUI (packaged from the
# upstream .deb in parts/pkgs/wifiman-desktop) and runs
# its privileged helper daemon `wifiman-desktopd` as a
# systemd service. The daemon performs the network
# scanning / device discovery and manages the Teleport
# WireGuard tunnel; the GUI is non-functional without it.
###################################################
{
  self',
  lib,
  ...
}: let
  wifiman-desktop = self'.packages.wifiman-desktop;
in {
  environment.systemPackages = [wifiman-desktop];

  systemd.services.wifiman-desktop = {
    description = "WiFiman Desktop daemon";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = lib.getExe' wifiman-desktop "wifiman-desktopd";
      User = "root";
      Restart = "always";
      RestartSec = 30;
    };
  };
}
