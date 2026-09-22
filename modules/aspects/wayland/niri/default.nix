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
    fuzzel
    playerctl
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
    nautilus
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
    # gnome fronts every interface, gtk only fills the ones gnome lacks
    # (Access, Notification). Forced because 26.05's upstream niri module
    # defines its own defaults, including FileChooser = gtk.
    config = {
      common.default = ["gnome" "gtk"];
      niri = {
        default = lib.mkForce ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce ["gnome"];
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
