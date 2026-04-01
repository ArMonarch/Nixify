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
      (builtins.map normalize aspects)
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
          "programs/fish"
          "programs/rmpc"
          "programs/common"
          "programs/firefox"
          "programs/ghostty"
          "programs/nixfetch"
          "programs/obs-studio"
          "programs/discord/legcord"
          "security"
          "services/mpd"
          "services/pipewire"
          "services/printing"
          "services/bluetooth"
          "system/network"
          "virtualization/docker"
          "virtualization/distrobox"
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
          "console/theme"
          "displayManager/greetd/tuigreet-niri"
          "gpu/intel-nvidia"
          "kernel/zen"
          "localization"
          "nix/settings"
          "nixpkgs"
          "programs/common"
          "programs/firefox"
          "programs/fish"
          "programs/ghostty"
          "programs/nixfetch"
          "programs/obs-studio"
          "programs/rmpc"
          "programs/discord/legcord"
          "quickshell/noctalia-shell"
          "services/bluetooth"
          "services/mpd"
          "services/pipewire"
          "services/power"
          "security"
          "system/network"
          "virtualization/distrobox"
          "virtualization/docker"
          "wayland/niri"
          "wayland/swaybg"
        ];
        extraModules = [
          inputs.hjem.nixosModules.default
          inputs.self.nixosModules.colorScheme
        ];
      };
    };

    maclaurin = mkNixosSystem {
      hostname = "maclaurin";
      username = "frenzfries";
      system = "aarch64-linux";
      modules = mkModulesFor "maclaurin" {
        aspects = [
          "boot-loader/grub"
          "boot-loader/grub/efi"
          "desktopManager/plasma"
          "displayManager/sddm"
          "localization"
          "programs/common"
          "programs/fish"
          "programs/ghostty"
          "nix/settings"
          "nixpkgs"
          "security"
          "system/network"
        ];
        extraModules = [
          inputs.hjem.nixosModules.default
          inputs.self.nixosModules.colorScheme
        ];
      };
    };
  };
}
