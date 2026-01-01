{
  imports = [../common.nix];

  services.desktopManager.gnome = {
    enable = true;
  };
}
