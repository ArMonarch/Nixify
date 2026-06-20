###################################################
# Noctalia Quickshell desktop shell with its runtime dependencies for NixOS
###################################################
{
  self',
  pkgs,
  ...
}: let
  noctalia-shell = self'.packages.noctalia-shell.override {
    inherit
      (pkgs)
      brightnessctl
      cliphist
      ddcutil
      imagemagick
      matugen
      wget
      wlsunset
      gpu-screen-recorder
      ;
  };
in {
  environment.corePackages = [noctalia-shell];
}
