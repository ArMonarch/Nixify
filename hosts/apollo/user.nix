{
  pkgs,
  username,
  self',
  ...
}: {
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "initial";
    name = username;
    home = "/home/${username}";
    extraGroups = ["wheel"];
    packages = with pkgs; [git ripgrep eza] ++ [self'.packages.nixvim];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
