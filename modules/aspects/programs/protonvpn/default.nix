###################################################
# Proton VPN official desktop client for NixOS
#
# The app relies on NetworkManager to manage VPN
# connections, which is provided by the
# `system/network` aspect.
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    proton-vpn
  ];
}
