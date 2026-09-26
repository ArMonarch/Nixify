###################################################
# Intel + NVIDIA hybrid graphics (PRIME offload) configuration for NixOS
###################################################
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {
    # Pinned ahead of nixpkgs: 595.x calls strncpy, which kernel 7.2 dropped.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "615.71.09";
      sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
      openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
      settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
      persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
    };

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

  environment.sessionVariables = {
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "iHD";
  };
}
