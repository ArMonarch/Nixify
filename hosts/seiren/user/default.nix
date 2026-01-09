{
  inputs',
  config,
  username,
  pkgs,
  ...
}: {
  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      libxcrypt-legacy
    ];
  };

  # user setup
  users.mutableUsers = true;
  users.users.${username} = {
    name = username;
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "initial";
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;

    packages =
      [
        pkgs.ghostty
        pkgs.fastfetch
        pkgs.htop
        pkgs.rose-pine-cursor
        pkgs.jetbrains.idea-oss
        pkgs.nyaa
        pkgs.qbittorrent
        pkgs.vlc
      ]
      ++ [
        inputs'.nixvim.packages.nixvim
      ];
  };

  # hjem user home management setup
  hjem.users.${username} = {
    enable = true;
    clobberFiles = true;
    directory = config.users.users.${username}.home;
    imports = [
      ./ghostty.nix
      ./git.nix
    ];
    xdg.config.files."niri/config.kdl" = {
      source = ./niri_config.kdl;
    };
  };
}
