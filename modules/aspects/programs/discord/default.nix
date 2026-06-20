###################################################
# Discord chat client for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
  ];
}
