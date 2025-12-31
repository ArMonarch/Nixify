{pkgs, ...}: {
  imports = [../common/default.nix];

  services.desktopManager.plasma6 = {
    enable = true;
  };

  environment.plasma6.excludePackages = [
    pkgs.kdePackages.elisa
    pkgs.kdePackages.kate
  ];
}
