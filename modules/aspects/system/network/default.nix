###################################################
# Sets the system hostname and enables NetworkManager for the user
###################################################
{
  lib,
  hostname,
  username,
  ...
}: {
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  # Cloudflare DNS, ahead of whatever DHCP hands out.
  networking.nameservers = lib.mkDefault ["1.1.1.1" "1.0.0.1"];

  users.users.${username} = {
    extraGroups = ["networkmanager"];
  };
}
