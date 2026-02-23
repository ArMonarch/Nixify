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
          "programs/common"
          "programs/firefox"
          "programs/fish"
          "security"
          "services/pipewire"
          "services/bluetooth"
          "services/printing"
          "system/network"
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

    apollo = mkNixosSystem {
      hostname = "apollo";
      username = "frenzfries";
      system = "x86_64-linux";
      modules = mkModulesFor "apollo" {
        aspects = [
          "boot-loader/grub"
          "kernel/zen"
          "localization"
          "nix/settings"
          "system/network"
          "security"
          "services/openssh"
        ];
      };
    };
  };
}
