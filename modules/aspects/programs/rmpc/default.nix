{
  pkgs,
  username,
  ...
}: {
  environment.corePackages = with pkgs; [rmpc];

  # rmpc config file
  hjem.users.${username}.xdg.config.files = {
    "rmpc/config.ron" = {
      type = "copy";
      source = ./config/default.ron;
    };
  };
}
