{pkgs, ...}: {
  environment.corePackages = [
    pkgs.distrobox
  ];
}
