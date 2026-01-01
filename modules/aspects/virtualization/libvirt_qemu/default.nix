{
  username,
  pkgs,
  ...
}: {
  virtualisation = {
    kvmgt.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
  };

  environment.corePackages = with pkgs; [
    virt-manager
    virt-viewer
  ];

  services.spice-vdagentd.enable = true;

  users.users.${username} = {
    extraGroups = ["libvirtd"];
  };
}
