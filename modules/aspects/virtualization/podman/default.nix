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

    podman = {
      enable = true;

      # Make Podman backwards compatible with Docker socket interface.
      # Certain interface elements will be different, but unless any
      # of said values are hardcoded, it should not pose a problem
      # for us.
      dockerCompat = true;
      dockerSocket.enable = true;

      defaultNetwork.settings.dns_enabled = true;

      autoPrune = {
        enable = true;
        flags = ["--all"];
        dates = "weekly";
      };
    };
  };

  environment.corePackages = with pkgs; [
    podman-compose
    podman-desktop
  ];

  users.users.${username} = {
    extraGroups = ["podman"];
  };
}
