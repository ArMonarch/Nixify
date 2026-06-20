###################################################
# Sets the system hostname and enables NetworkManager for the user
###################################################
{
  hostname,
  username,
  ...
}: {
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  users.users.${username} = {
    extraGroups = ["networkmanager"];
  };
}
