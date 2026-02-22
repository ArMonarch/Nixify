{
  username,
  pkgs,
  ...
}: {
  virtualisation = {
    # Registries to search for images on `podman pull`
    containers.registries.search = [
      "docker.io"
      "quay.io"
      "ghcr.io"
      "gcr.io"
    ];
    docker = {
      enable = true;
    };
  };

  # set the distrobox container manager environment variable to docker
  # even if distrobox is not installed
  # later move this to dostrobox and add checks if either
  # docker or podman is enabled if distrobox is enabled
  environment.sessionVariables = {
    DISTROBOX_CONTAINER_MANAGER = "docker";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.${username} = {
    extraGroups = [
      "docker"
    ];
  };
}
