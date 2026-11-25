{username, ...}: {
  # A VMware Fusion guest on an Apple Silicon Mac (mitchellh/nixos-config
  # style), switched from macOS with the Makefile at the repo root; see
  # `make help`.
  imports = [
    ./clipboard.nix # Mac <-> VM copy and paste
    ./fs.nix
    ./hardware.nix
    ./user.nix # includes the hjem home setup
  ];

  # open-vm-tools: time sync, clean shutdown, guest info. Not headless (the
  # default without X11), so the clipboard agent and its vmblock mount exist.
  virtualisation.vmware.guest = {
    enable = true;
    headless = false;
  };

  # The VM sits behind Fusion's NAT, reachable only from the Mac.
  networking.firewall.enable = false;

  # `make vm/deploy` runs these two over ssh with no terminal for a password
  # prompt; every other sudo still asks.
  security.sudo.extraRules = [
    {
      users = [username];
      commands = [
        {
          command = "/run/current-system/sw/bin/rsync";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  time.timeZone = "Asia/Kathmandu";

  # The release of the first install; leave it alone.
  system.stateVersion = "26.05";
}
