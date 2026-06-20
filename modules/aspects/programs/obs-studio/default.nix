###################################################
# OBS Studio configuration for NixOS with CUDA and PipeWire support
###################################################
{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
      pipewireSupport = true;
    };
  };
}
