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
