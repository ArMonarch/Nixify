###################################################
# Ladybird web browser for NixOS
#
# Taken from nixpkgs-unstable: the stable snapshot
# trails master by months.
###################################################
{inputs', ...}: {
  environment.systemPackages = [inputs'.nixpkgs-unstable.legacyPackages.ladybird];
}
