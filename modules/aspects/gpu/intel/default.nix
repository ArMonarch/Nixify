###################################################
# Intel integrated graphics configuration for NixOS
###################################################
{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API video decode/encode (Broadwell and newer)
      vpl-gpu-rt # Quick Sync Video via oneVPL (Tiger Lake and newer)
    ];
  };

  services.xserver.videoDrivers = ["modesetting"];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
