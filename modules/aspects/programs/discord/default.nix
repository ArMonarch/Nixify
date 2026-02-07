{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    discord
  ];
}
