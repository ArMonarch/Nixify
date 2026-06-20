###################################################
# Legcord lightweight Discord client for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    legcord
  ];
}
