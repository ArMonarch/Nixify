###################################################
# RPCS3 PlayStation 3 emulator for NixOS
#
# nixpkgs marks it unfree (vendored wolfSSL licence
# clash), so Hydra never caches it and it builds
# locally. Needs the `nixpkgs` aspect for allowUnfree.
###################################################
{pkgs, ...}: {
  environment.systemPackages = [pkgs.rpcs3];

  # The package ships hidraw rules for DualShock 3/4 and DualSense; without
  # them RPCS3 cannot open the controllers as a normal user.
  services.udev.packages = [pkgs.rpcs3];

  # RPCS3 locks guest memory and warns, then stutters or crashes, under the
  # kernel's 64 KiB default RLIMIT_MEMLOCK.
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-"; # soft and hard
      item = "memlock";
      value = "unlimited";
    }
  ];
}
