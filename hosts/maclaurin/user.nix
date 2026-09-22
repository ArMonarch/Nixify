{
  lib,
  pkgs,
  config,
  inputs',
  username,
  ...
}: let
  inherit (lib.generators) toGitINI;
  gitUsername = "ArMonarch";
  gitEmail = "praffulthapa12@gmail.com";
in {
  users.users.frenzfries = {
    name = username;
    isNormalUser = true;
    initialPassword = "initial";
    extraGroups = ["networkmanager" "wheel"];
    home = "/home/${username}";
    shell = pkgs.fish;
    packages = [
      inputs'.nixvim.packages.nixvim
    ];
  };

  hjem.users.${username} = {
    enable = true;
    clobberFiles = true;
    directory = config.users.users.${username}.home;
    imports = [];

    xdg.config.files = {
      "git/config" = {
        generator = toGitINI;
        value = {
          user.name = gitUsername;
          user.email = gitEmail;

          push.default = "simple";
          core.askPass = ""; # empty so git asks in the terminal

          # credential.helper = "cache --timeout=21600"; # alternative, 6 hrs
          credential.helper = "store";
          init.defaultBranch = "master";
          log.decorate = "full"; # branch/tag info in git log
          log.date = "iso";
          merge.conflictStyle = "diff3"; # readable three-way conflicts
        };
      };
    };
  };
}
