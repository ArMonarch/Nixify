###################################################
# Enables Podman with Docker compatibility, auto-pruning, and Distrobox integration
###################################################
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

      # Docker socket compatibility; fine unless a socket path is hardcoded.
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

  environment.sessionVariables = {
    DISTROBOX_CONTAINER_MANAGER = "podman";
  };

  environment.systemPackages = [
    pkgs.distrobox
  ];

  users.users.${username} = {
    extraGroups = ["podman"];
  };
}
