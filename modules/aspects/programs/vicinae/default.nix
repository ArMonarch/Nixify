###################################################
# Vicinae: Raycast-style launcher (apps, windows, clipboard,
# calculator, emoji). niri binds Alt+Space to `vicinae toggle`.
###################################################
{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.vicinae
    pkgs.pulseaudio
  ];

  # The package ships vicinae.service (`vicinae server`); start it with the session.
  systemd.packages = [pkgs.vicinae];
  systemd.user.services.vicinae = {
    wantedBy = ["graphical-session.target"];
    environment = {
      # Apps launched from vicinae inherit this; keep the session PATH, not
      # NixOS's minimal unit PATH (coreutils, grep, ...).
      PATH = lib.mkForce null;
    };
  };
}
