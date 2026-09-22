###################################################
# Ubiquiti WiFiman Desktop for NixOS. The privileged
# daemon `wifiman-desktopd` runs as a systemd
# service; the GUI is non-functional without it.
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
