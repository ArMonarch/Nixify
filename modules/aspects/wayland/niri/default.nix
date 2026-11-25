###################################################
# Niri Wayland compositor with portals, utilities, and user config for NixOS
###################################################
{
  lib,
  pkgs,
  username,
  ...
}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    playerctl
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
  ];

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
  };

  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce (with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ]);
    # gtk handles everything except screen capture, which needs gnome (niri
    # implements Mutter's ScreenCast API). Forced because 26.05's upstream
    # niri module defines its own defaults.
    config = {
      common.default = ["gtk"];
      niri = {
        default = lib.mkForce ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = lib.mkForce ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = lib.mkForce ["gnome"];
        "org.freedesktop.impl.portal.RemoteDesktop" = lib.mkForce ["gnome"];
      };
    };
  };

  hjem.users.${username}.xdg.config.files = {
    "niri/config.kdl" = {
      type = "copy";
      source = ./niri_config.kdl;
    };
  };
}
