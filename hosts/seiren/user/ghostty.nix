{
  lib,
  pkgs,
  ...
}: let
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
in {
  xdg.config.files = {
    "ghostty/config" = {
      type = "copy";
      generator = keyValue.generate "config";
      value = {
        # Window Padding
        window-padding-x = 0;
        window-padding-y = 0;
        window-padding-balance = true;
        window-padding-color = "extend";
        window-vsync = true;

        # working directory
        working-directory = "home";
        window-inherit-working-directory = true;

        # window property
        window-decoration = "none";
        window-theme = "system";
        window-save-state = "never";

        # shell integration features
        shell-integration-features = "no-cursor, title, ssh-terminfo, ssh-env";

        # Cursor Customization
        cursor-style = "block";
        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        # Configure the font family for ghostty
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;

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

          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
        ];
      };
    };
  };
}
