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
        pkgs.lazygit
        pkgs.rose-pine-cursor
        pkgs.scrcpy
        pkgs.mangohud
        pkgs.nyaa
        pkgs.qbittorrent
        pkgs.vlc
        pkgs.zed-editor
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
      ./git.nix
    ];
  };
}
