{
  inputs',
  config,
  username,
  pkgs,
  ...
}: {
  # nixvim below; zed isn't on this host yet
  environment.variables = {EDITOR = "nvim";};

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
        pkgs.gnumake # the repo Makefile, `make switch` inside the VM
        pkgs.lazygit
        pkgs.rose-pine-cursor
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
      # same identity as seiren
      ../seiren/user/git.nix
    ];
  };
}
