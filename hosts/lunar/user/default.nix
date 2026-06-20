{
  inputs',
  config,
  username,
  pkgs,
  ...
}: {
  # nix-ld config
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
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

    packages = with pkgs;
      [
        gh
        wl-clipboard
        lazygit
        nyaa
        qbittorrent
        vlc
        thunderbird
        libreoffice-qt-fresh
      ]
      ++ [
        inputs'.nixvim.packages.nixvim
        inputs'.claude-code.packages.claude-code
      ];
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
}
