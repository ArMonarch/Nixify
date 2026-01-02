{modulesPath, ...}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd = {
    availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];
  };

  boot.kernelModules = ["kvm-intel"];
}
