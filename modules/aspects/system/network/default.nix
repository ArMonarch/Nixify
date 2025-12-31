{
  hostname,
  username,
  ...
}: {
  networking.hostName = "${username}__${hostname}";
  networking.networkmanager.enable = true;

  users.users.${username} = {
    extraGroups = ["networkmanager"];
  };
}
