{
  inputs',
  config,
  username,
  pkgs,
  ...
}: {
  # user setup
  users.mutableUsers = true;
  users.users.${username} = {
    name = username;
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "initial";
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;

    packages = with pkgs;
      [
        wl-clipboard
        lazygit
        nyaa
        qbittorrent
        vlc
        thunderbird
      ]
      ++ [inputs'.nixvim.packages.nixvim];
  };

  # hjem user home management setup
  hjem.users.${username} = {
    enable = true;
    clobberFiles = true;
    directory = config.users.users.${username}.home;
    imports = [
      ./config_files.nix
    ];
  };
  hjem.linker = inputs'.smfh.packages.default;
}
