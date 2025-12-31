{
  username,
  pkgs,
  ...
}: {
  users.mutableUsers = true;
  users.users.${username} = {
    name = username;
    extraGroups = ["networkmanager" "wheel"];
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;
  };
}
