{lib, ...}: let
  inherit (lib.generators) toGitINI;
  gitUsername = "ArMonarch";
  gitEmail = "praffulthapa12@gmail.com";
in {
  xdg.config.files = {
    # git config
    "git/config" = {
      generator = toGitINI;
      value = {
        user.name = gitUsername;
        user.email = gitEmail;

        push.default = "simple"; # Match modern push behavior
        core.askPass = ""; # needs to be empty to use terminal for ask pass

        # Cache timeout set to 6 Hrs
        # 12 hrs = 43,200
        # 6 hrs = 21,600
        # 2 hrs = 7,200
        # credential.helper = "cache --timeout=21600";
        credential.helper = "store";
        # Set default new branches to 'master'
        init.defaultBranch = "master";
        # FOSS-friendly settings
        log.decorate = "full"; # Show branch/tag info in git log
        log.date = "iso"; # ISO 8601 date format
        # Conflict resolution style for readable diffs
        merge.conflictStyle = "diff3";
      };
    };
  };
}
