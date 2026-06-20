###################################################
# Installs the Distrobox container management tool system wide
###################################################
{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.distrobox
  ];
}
