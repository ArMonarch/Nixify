{
  inputs,
  lib,
  nixify-lib,
  ...
}: let
  inherit (lib) concatLists singleton;
  inherit (nixify-lib) mkNixosSystem;

  # Specify root path for the modules. The concept is similar to modulesPath
  # that is found in nixpkgs
  modulePath = ../modules;

  aspectPaths = modulePath + /aspects; # the module that define an aspect of the confuguration

  mkModulesFor = host: {
    aspects ? [],
    extraModules ? [],
  }: let
    normalize = aspect:
      if builtins.isString aspect
      then aspectPaths + /${aspect}
      else throw "type of aspect must be string";
  in
    concatLists [
      (singleton ./${host}/host.nix)
      (map normalize aspects)
      extraModules
    ];
in {
  flake.nixosConfigurations = {
    base = mkNixosSystem {
      hostname = "base";
      username = "frenzfries";
      system = "x86_64-linux";
      modules = mkModulesFor "base" {};
    };

    lunar = mkNixosSystem {
      hostname = "lunar";
      username = "frenzfries";
      system = "x86_64-linux";
      modules = mkModulesFor "lunar" {
        aspects = [
          "boot-loader/grub"
          "boot-loader/grub/efi"
          "cpu/intel"
          "console/theme"
          "desktopManager/plasma"
          "displayManager/sddm"
          "gpu/intel-nvidia"
          "kernel/zen"
          "localization"
          "nix/settings"
          "nixpkgs"
          "programs/zed"
          "programs/fish"
          "programs/rmpc"
          "programs/essentials"
          "programs/ghostty"
          "programs/nixfetch"
          "programs/obs-studio"
          "programs/firefox/nightly"
          "programs/discord/legcord"
          "security"
          "services/mpd"
          "services/pipewire"
          "services/printing"
          "services/bluetooth"
          "system/network"
          "wayland/swaybg"
        ];
        extraModules = [
          inputs.hjem.nixosModules.default
          inputs.self.nixosModules.colorScheme
        ];
      };
    };

    seiren = mkNixosSystem {
      hostname = "seiren";
      username = "frenzfries";
      system = "x86_64-linux";
      modules = mkModulesFor "seiren" {
        aspects = [
          "boot-loader/grub"
          "boot-loader/grub/efi"
          "cpu/intel"
          "colorScheme/rose-pine"
          "console/theme"
          "displayManager/greetd/tuigreet-niri"
          "gpu/intel-nvidia"
          "input/mac-shortcuts"
          "kernel/zen"
          "localization"
          "nix/settings"
          "nixpkgs"
          "programs/aseprite"
          "programs/chrome"
          "programs/essentials"
          "programs/firefox"
          "programs/fish"
          "programs/ghostty"
          "programs/vicinae"
          "programs/nixfetch"
          "programs/raddebugger"
          "programs/mpv"
          "programs/obs-studio"
          "programs/rmpc"
          "programs/zed"
          "services/bluetooth"
          "services/mpd"
          "services/pipewire"
          "services/power"
          "security"
          "system/network"
          "wayland/niri"
          "wayland/swaybg"
        ];
        extraModules = [
          inputs.hjem.nixosModules.default
          inputs.self.nixosModules.colorScheme
        ];
      };
    };

    # VMware Fusion guest on the Mac. Minimal for now; grow it toward seiren.
    maclaurin = mkNixosSystem {
      hostname = "maclaurin";
      username = "frenzfries";
      system = "aarch64-linux";
      modules = mkModulesFor "maclaurin" {
        aspects = [
          "boot-loader/systemd-boot"
          "colorScheme/rose-pine"
          "console/theme"
          "displayManager/greetd/tuigreet-niri"
          "gpu/vmware"
          "input/mac-shortcuts"
          "programs/essentials"
          "programs/fish"
          "programs/firefox"
          "programs/ghostty"
          "programs/ladybird"
          "programs/vicinae"
          "programs/nixfetch"
          "security"
          "system/network"
          "wayland/niri"
          "wayland/swaybg"

          # keep `make vm/deploy` working: flakes, unfree (claude-code), ssh
          "nix/settings"
          "nixpkgs"
          "services/openssh"
        ];
        extraModules = [
          inputs.hjem.nixosModules.default
          inputs.self.nixosModules.colorScheme
        ];
      };
    };
  };
}
