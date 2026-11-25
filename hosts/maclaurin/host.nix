{username, ...}: {
  # A VMware Fusion guest on an Apple Silicon Mac (mitchellh/nixos-config
  # style), switched from macOS with the Makefile at the repo root; see
  # `make help`.
  imports = [
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

  # The agent only autostarts in X sessions. Under niri it runs against
  # xwayland-satellite's DISPLAY, which bridges the X clipboard to Wayland.
  systemd.user.services.vmware-user = {
    description = "VMware user agent (host clipboard, drag and drop)";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "/run/wrappers/bin/vmware-user-suid-wrapper";
      Restart = "on-failure";
      RestartSec = 2;
    };
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
