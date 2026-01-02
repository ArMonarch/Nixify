{
  hostname,
  username,
  ...
}: {
  networking.hostName = "${username}X${hostname}";
  networking.networkmanager.enable = true;

  users.users.${username} = {
    extraGroups = ["networkmanager"];
  };
}
