{
  imports = [../common/default.nix];

  services.desktopManager.gnome = {
    enable = true;
  };
}
