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

  environment.corePackages = with pkgs; [
    remmina
  ];

  # user setup
  users.mutableUsers = true;
  users.users.${username} = {
    name = username;
    extraGroups = ["wheel"];
    initialPassword = "initial";
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;

    packages =
      [
        pkgs.fastfetch
        pkgs.oculante
        pkgs.kdePackages.okular
        pkgs.htop
        pkgs.rose-pine-cursor
        pkgs.jetbrains.idea-oss
        pkgs.nyaa
        pkgs.tailscale
        pkgs.qbittorrent
        pkgs.vlc
        pkgs.rhythmbox
        pkgs.postman
        pkgs.thunderbird
        pkgs.mysql-workbench
        pkgs.zed-editor
        pkgs.zellij
        pkgs.code-cursor-fhs
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
      ./git.nix
    ];
    xdg.config.files."niri/config.kdl" = {
      source = ./niri_config.kdl;
    };
  };
}
