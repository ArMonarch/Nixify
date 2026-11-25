###################################################
# Ladybird web browser for NixOS
#
# Taken from nixpkgs-unstable: the stable snapshot
# trails master by months.
###################################################
{
  inputs',
  pkgs,
  ...
}: {
  environment.systemPackages = [inputs'.nixpkgs-unstable.legacyPackages.ladybird];

  # Ladybird's font fallback lists name these families.
  fonts.packages = [pkgs.dejavu_fonts pkgs.liberation_ttf];
}
