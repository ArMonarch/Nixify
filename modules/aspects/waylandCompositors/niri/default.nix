{pkgs, ...}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.corePackages = with pkgs; [
    ghostty
    fuzzel
    xkeyboard-config
    wl-clipboard
  ];
}
