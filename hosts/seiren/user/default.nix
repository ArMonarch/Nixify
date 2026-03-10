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
    extraGroups = ["wheel"];
    initialPassword = "initial";
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;

    packages =
      [
        pkgs.fastfetch
        pkgs.oculante
        pkgs.htop
        pkgs.rose-pine-cursor
        pkgs.nyaa
        pkgs.qbittorrent
        pkgs.vlc
        pkgs.thunderbird
        pkgs.zed-editor
      ]
      ++ [
        inputs'.nixvim.packages.nixvim
        inputs'.claude-code.packages.claude-code-bun
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
  };
}
