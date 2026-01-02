{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.generators) toGitINI;
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
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

    # ghostty config
    "ghostty/config" = {
      generator = keyValue;
      value = {
        # Window Padding
        window-padding-x = 0;
        window-padding-y = 0;
        window-padding-balance = true;

        # Window Size
        window-width = 160;
        window-height = 40;

        # Window Position
        window-position-x = 0;
        window-position-y = 0;

        # Window Decoration
        window-decoration = "server";

        # shell integration features
        shell-integration-features = "no-cursor, title, ssh-terminfo, ssh-env";

        # Cursor Customization
        cursor-style = "block";
        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        # Configure the font family for ghostty
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        adjust-cell-height = "1.20%";

        # Theme
        # Automatic dark/light switching
        # theme = "light:Rose Pine Dawn, dark:Rose Pine Moon";
        # theme = "light:Catppuccin Latte, dark:Catppuccin Mocha";
        theme = "light:TokyoNight Day, dark:TokyoNight Night";

        # window transparency customization
        background-opacity = 0.94;
        background-blur-radius = 20;

        # Resize Configuration
        resize-overlay = "always";
        resize-overlay-position = "bottom-right";

        # Key Bindings
        keybind = [
          "ctrl+shift+|=new_split:right"
          "ctrl+shift+-=new_split:down"

          "ctrl+shift+j=goto_split:bottom"
          "ctrl+shift+k=goto_split:top"
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+l=goto_split:right"

          "ctrl+shift+n=new_window"
          "ctrl+shift+t=new_tab"

          "ctrl+q=close_surface"
          "alt+g=toggle_window_decorations"
        ];
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
