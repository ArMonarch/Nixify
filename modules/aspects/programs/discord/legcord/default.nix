{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    legcord
  ];
}
