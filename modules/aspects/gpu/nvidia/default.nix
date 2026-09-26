###################################################
# NVIDIA dedicated GPU driver configuration for NixOS
###################################################
{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    # Pinned ahead of nixpkgs: 595.x calls strncpy, which kernel 7.2 dropped.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "615.71.09";
      sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
      openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
      settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
      persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
    };
    nvidiaSettings = true;
  };

  environment.sessionVariables = {
    NVD_BACKEND = "direct";
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}
