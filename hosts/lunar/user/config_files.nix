{lib, ...}: let
  inherit (lib.generators) toGitINI;
  gitUsername = "ArMonarch";
  gitEmail = "praffulthapa12@gmail.com";
in {
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

    "kglobalshortcutsrc".text = ''
      [ActivityManager]
      _k_friendly_name=Activity Manager

      [kwin]
      _k_friendly_name=kwin
      Window Maximize=Ctrl+Meta+Up,none,Maximize Window
      Window Minimize=Ctrl+Meta+Down,none,Minimize Window
      Window Close=Alt+F4,none,Close Window

      [services][com.mitchellh.ghostty.desktop]
      _launch=Ctrl+Alt+t
      new-window=none

      [services][org.kde.spectacle.desktop]
      _launch=none
      ActiveWindowScreenShot=Alt+Print
      CurrentMonitorScreenShot=none
      FullScreenScreenShot=Meta+Print
      OpenWithoutScreenshot=none
      RecordRegion=none
      RecordScreen=Ctrl+Alt+R
      RecordWindow=none
      RectangularRegionScreenShot=Print
      WindowUnderCursorScreenShot=none
    '';
  };
}
