###################################################
# macOS-style Super+C/V/X/A/Z editing shortcuts. Apps that can bind
# super natively (ghostty, zed, aseprite, scrcpy) do so themselves;
# xremap covers the rest (browsers, electron, gtk), where Ctrl+C only copies.
###################################################
{
  lib,
  pkgs,
  username,
  ...
}: let
  # These bind every Super shortcut themselves, so xremap leaves them alone.
  # Aseprite's XWayland class is "Aseprite"; the regex spares guessing its case.
  native = ["com.mitchellh.ghostty" "dev.zed.Zed" "/^[Aa]seprite$/"];

  # scrcpy binds Super+C/X/V to device copy/cut/paste, but Super+A/Z are its
  # own commands (Super+Z pauses the display), so those still go to Android.
  scrcpy = "scrcpy";

  # exact_match stops Super+Shift/Ctrl combos (niri binds) from being eaten.
  config = (pkgs.formats.yaml {}).generate "xremap.yaml" {
    keymap = [
      {
        name = "scrcpy: Android select all, undo and redo";
        application.only = [scrcpy];
        exact_match = true;
        remap = {
          "Super-a" = "C-a";
          "Super-z" = "C-z";
          "Super-Shift-z" = "C-Shift-z";
          # Ctrl+Y is not redo everywhere on Linux; Ctrl+Shift+Z is.
          "Super-y" = "C-Shift-z";
        };
      }
      {
        name = "mac shortcuts for apps without a super binding";
        application.not = native ++ [scrcpy];
        exact_match = true;
        remap = {
          "Super-c" = "C-c";
          "Super-v" = "C-v";
          "Super-x" = "C-x";
          "Super-a" = "C-a";
          "Super-z" = "C-z";
          "Super-Shift-z" = "C-Shift-z";
          # Ctrl+Y is not redo everywhere on Linux; Ctrl+Shift+Z is.
          "Super-y" = "C-Shift-z";
        };
      }
    ];
  };
in {
  # xremap reads keyboards from /dev/input and writes a virtual one to /dev/uinput.
  hardware.uinput.enable = true;
  users.users.${username}.extraGroups = ["input" "uinput"];

  # A user service, since the niri client needs this session's NIRI_SOCKET.
  systemd.user.services.xremap = {
    description = "xremap macOS-style shortcuts";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.xremap.niri} --watch=device ${config}";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
