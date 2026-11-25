{
  # Labels, not UUIDs, so a reinstalled VM needs no edit.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NixOS";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/Boot";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];
}
