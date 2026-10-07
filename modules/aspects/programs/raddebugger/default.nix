###################################################
# RAD Debugger for NixOS
#
# Native graphical debugger, shipped with radbin
# and radlink.
###################################################
{self', ...}: {
  # Built from master in parts/pkgs/raddbg; `nix flake update raddebugger` bumps it.
  environment.systemPackages = [self'.packages.raddebugger];
}
