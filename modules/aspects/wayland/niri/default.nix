{pkgs, ...}: {
  programs.niri = {
    enable = true;
    useNautilus = true;
  };

  environment.corePackages = with pkgs; [
    brightnessctl
    fuzzel
    playerctl
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
    nautilus
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
