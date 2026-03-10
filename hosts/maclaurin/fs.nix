{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dfcb07ee-4cc9-4b78-b76f-22aaddda9096";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8E99-9B4B";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };
}
