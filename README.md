# Nixify

A modular NixOS configuration using the **aspects pattern** for composable system configuration.

## Structure

```
.
├── flake.nix              # Flake entry point
├── hosts/                 # Host-specific configurations
│   ├── <hostname>/
│   │   ├── host.nix       # Host config and aspect overrides
│   │   ├── fs.nix         # Filesystem layout
│   │   ├── hardware.nix   # Hardware configuration
│   │   └── user/          # User and home setup (hjem)
│   └── default.nix        # Host definitions and aspect lists
├── modules/
│   ├── aspects/           # Reusable configuration modules
│   └── options/           # Custom option definitions
└── parts/                 # Flake parts (lib, packages, modules)
```

## Aspects

Aspects are self-contained, composable configuration modules. Each aspect configures a specific feature of the system.

### Available Aspects

| Category | Aspects |
|----------|---------|
| boot-loader | `grub`, `grub/efi`, `systemd-boot` |
| console | `fonts`, `theme` |
| cpu | `intel` |
| desktopManager | `gnome`, `plasma` |
| displayManager | `gdm`, `sddm`, `greetd/tuigreet-niri` |
| gpu | `intel`, `intel-nvidia`, `nvidia`, `vmware` |
| input | `mac-shortcuts` |
| kernel | `latest`, `zen` |
| localization | default |
| nix | `settings` |
| nixpkgs | default |
| programs | `common`, `discord/*`, `firefox`, `ghostty`, `obs-studio`, `rmpc` |
| security | default, `firewall` |
| services | `bluetooth`, `dbus`, `mpd`, `openssh`, `pipewire`, `power`, `printing`, `pulseaudio` |
| shell | `fish` |
| system | `network` |
| virtualization | `distrobox`, `docker`, `libvirt_qemu`, `podman` |
| wayland | `niri`, `swaybg` |

## Usage

### Adding Aspects to a Host

In `hosts/default.nix`, add aspects to the host's aspect list:

```nix
seiren = mkNixosSystem {
  hostname = "seiren";
  username = "frenzfries";
  system = "x86_64-linux";
  modules = mkModulesFor "seiren" {
    aspects = [
      "boot-loader/grub"
      "boot-loader/grub/efi"
      "kernel/zen"
      "services/pipewire"
      "programs/firefox"
      # ... add more aspects
    ];
  };
};
```

### Creating a New Host

1. Create directory `hosts/<hostname>/`

2. Add required files:
   ```
   hosts/<hostname>/
   ├── host.nix      # Main config, imports, and overrides
   ├── fs.nix        # Filesystem mounts
   ├── hardware.nix  # Hardware-specific settings
   └── user/         # User configuration (optional)
   ```

3. Add host definition in `hosts/default.nix`:
   ```nix
   <hostname> = mkNixosSystem {
     hostname = "<hostname>";
     username = "<username>";
     system = "x86_64-linux";
     modules = mkModulesFor "<hostname>" {
       aspects = [
         # list your aspects here
       ];
     };
   };
   ```

### Creating a New Aspect

1. Create `modules/aspects/<category>/<name>/default.nix`:
   ```nix
   { pkgs, config, lib, ... }: {
     # Your configuration here
     environment.systemPackages = [ pkgs.example ];
   }
   ```

2. Use the aspect by adding `"<category>/<name>"` to a host's aspect list.

### Overriding Aspect Options

Override aspect defaults in your host's `host.nix`:

```nix
{
  imports = [ ./fs.nix ./hardware.nix ./user ];

  # Override aspect options
  nixify.aspect.programs.ghostty.font = "iosevka";
  system.modules.shell.fish.features.integrations = ["eza" "git"];

  # Standard NixOS options
  time.timeZone = "Asia/Kathmandu";
  system.stateVersion = "25.05";
}
```

## Building

```bash
# Switch to configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Test configuration
sudo nixos-rebuild test --flake .#<hostname>
```

## NixOS VM on macOS (`maclaurin`)

Following [mitchellh/nixos-config](https://github.com/mitchellh/nixos-config): macOS stays the
host, and the seiren desktop (niri, rose-pine, zed, ghostty, fish) runs as a VMware Fusion
guest that the repo `Makefile` drives over ssh.

1. In VMware Fusion, create a VM from the NixOS **aarch64** ISO ("Other Linux 6.x kernel 64-bit
   Arm", 4+ cores, 8+ GB RAM, 100+ GB disk, *Display → Accelerate 3D Graphics* on, NAT network)
   and install NixOS by hand. `hosts/maclaurin/fs.nix` mounts by label: root `mkfs.ext4 -L NixOS`,
   EFI `mkfs.fat -F 32 -n Boot`. Swap is a 4 GiB swapfile, so no swap partition.
2. First switch, inside the VM (flakes aren't on yet in a fresh install):
   ```bash
   nix-shell -p git --run "git clone https://github.com/ArMonarch/Nixify.git ~/Nixify"
   cd ~/Nixify
   sudo nixos-rebuild boot --flake .#maclaurin --option experimental-features "nix-command flakes"
   sudo reboot
   ```
3. Day to day, push edits from the Mac (`ip a` in the VM for the address; user `frenzfries`,
   password `initial` until you change it):
   ```bash
   make vm/deploy NIXADDR=<ip>   # rsync this repo to /nixify in the VM and switch
   ```

## Dependencies

- [flake-parts](https://github.com/hercules-ci/flake-parts) - Modular flake framework
- [hjem](https://github.com/feel-co/hjem) - Home configuration (home-manager alternative)

## License
MIT
