{
  # VMware Fusion on Apple Silicon: virtual NVMe/SATA disks, xHCI USB.
  boot.initrd.availableKernelModules = [
    "uhci_hcd"
    "ahci"
    "xhci_pci"
    "nvme"
    "usbhid"
    "sr_mod"
  ];
}
