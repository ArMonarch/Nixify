###################################################
# Boots the Zen Linux kernel for NixOS
###################################################
{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
}
