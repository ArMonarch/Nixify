{username, ...}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/211daeba-5b1c-4a2e-8fcb-137aced84fac";
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0F70-D526";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    # Windows partation mount as /home/${username}/Windows.
    "/home/${username}/Windows" = {
      device = "/dev/disk/by-uuid/62A443AFA443850F";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000"
        "gid=1000"
        "x-gvfs-name=Windows"
      ];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
}
