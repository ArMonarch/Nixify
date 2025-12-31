{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;

    # Optimized configuration for switchable graphics laptops
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # disable other prime
    prime.reverseSync.enable = mkForce false;
    prime.sync.enable = mkForce false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };

  # Additional useful packages
  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
  ];
}
