###################################################
# Vesktop custom Discord client for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vesktop
  ];
}
