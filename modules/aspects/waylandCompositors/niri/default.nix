{pkgs, ...}: {
  programs.niri = {
    enable = true;
  };

  environment.corePackages = with pkgs; [
    ghostty
    fuzzel
    xkeyboard-config
    wl-clipboard
    playerctl
    brightnessctl
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
