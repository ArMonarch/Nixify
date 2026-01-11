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
      ;
  };
in {
  environment.corePackages = [noctalia-shell];
}
