###################################################
# Ladybird browser for NixOS
#
# Independent engine (LibWeb/LibJS), still pre-alpha,
# so it sits beside a daily-driver browser.
###################################################
{self', ...}: {
  # Built from master in parts/pkgs/ladybird; `nix flake update ladybird` bumps it.
  environment.systemPackages = [self'.packages.ladybird];
}
