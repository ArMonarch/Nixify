###################################################
# Enables the Docker daemon with image registries, docker-compose, and Distrobox integration
###################################################
{
  username,
  pkgs,
  ...
}: {
  virtualisation = {
    # Registries to search for images on pull.
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

  # TODO: move to the distrobox aspect and assert docker or podman is enabled.
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
