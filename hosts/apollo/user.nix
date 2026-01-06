{
  pkgs,
  username,
  inputs',
  ...
}: {
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "initial";
    name = username;
    home = "/home/${username}";
    extraGroups = ["wheel"];
    packages = with pkgs; [git ripgrep eza] ++ [inputs'.nixvim.packages.nixvim];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
