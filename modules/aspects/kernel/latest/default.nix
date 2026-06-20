###################################################
# Boots the latest mainline Linux kernel for NixOS
###################################################
{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
