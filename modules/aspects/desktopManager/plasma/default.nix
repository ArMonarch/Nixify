###################################################
# KDE Plasma 6 desktop environment configuration for NixOS
###################################################
{pkgs, ...}: {
  imports = [../common.nix];

  services.desktopManager.plasma6 = {
    enable = true;
  };

  environment.plasma6.excludePackages = [
    pkgs.kdePackages.elisa
    pkgs.kdePackages.kate
  ];
}
