{pkgs, ...}: {
  environment.sessionVariables = {
    DISTROBOX_CONTAINER_MANAGER = "docker";
  };

  environment.corePackages = [
    pkgs.distrobox
    pkgs.distrobox-tui
  ];
}
