{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
      pulseaudioSupport = true;
      pipewireSupport = true;
    };
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
