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

  environment.corePackages = with pkgs; [
    docker-compose
  ];

  users.users.${username} = {
    extraGroups = [
      "docker"
    ];
  };
}
