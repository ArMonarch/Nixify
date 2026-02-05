{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
      pulseaudioSupport = false;
      pipewireSupport = true;
    };
  };
}
