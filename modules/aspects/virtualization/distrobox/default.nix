{pkgs, ...}: {
  environment.corePackages = [
    pkgs.distrobox
    pkgs.distrobox-tui
  ];
}
