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
        pkgs.nyaa
        pkgs.qbittorrent
        pkgs.vlc
        pkgs.thunderbird
        pkgs.zed-editor
        pkgs.vscode-fhs
      ]
      ++ [
        inputs'.nixvim.packages.nixvim
      ];
  };

  # hjem user home management setup
  hjem.linker = inputs'.smfh.packages.default;
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
