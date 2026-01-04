{
  self',
  pkgs,
  ...
}: {
  environment.corePackages = [
    (self'.packages.noctalia-shell.override
      {
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
      })
  ];
}
