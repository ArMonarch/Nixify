{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    libnotify
    wl-clipboard
  ];
}
