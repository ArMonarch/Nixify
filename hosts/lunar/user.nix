{
  username,
  pkgs,
  ...
}: {
  users.mutableUsers = true;
  users.users.${username} = {
    name = username;
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "initial";
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;

    packages = with pkgs; [
      ghostty
      fastfetch
      wl-clipboard
      lazygit
      nyaa
      qbittorrent
      vlc
    ];
  };
}
