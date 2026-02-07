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
  options = modulePath + /options; # the module that provides the options for my system configuration

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
      (singleton options)

      (builtins.map normalize aspects)
      (singleton ./${host}/host.nix)

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
          "boot/kernel/zen"
          "boot-loader/grub"
          "boot-loader/efi-support"
          "cpu/intel"
          "console/theme"
          "desktopManager/plasma"
          "displayManager/sddm"
          "gpu/intel-nvidia"
          "localization"
          "nix/settings"
          "nixpkgs"
          "programs/common"
          "programs/firefox"
          "security"
          "services/pipewire"
          "services/bluetooth"
          "services/printing"
          "shell/fish"
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
          "boot/kernel/zen"
          "boot-loader/grub"
          "boot-loader/efi-support"
          "cpu/intel"
          "console/fonts"
          "console/theme"
          "displayManager/greetd/tuigreet-niri"
          "gpu/intel-nvidia"
          "localization"
          "nix/settings"
          "nixpkgs"
          "programs/common"
          "programs/firefox"
          "programs/discord/legcord"
          "quickshell/noctalia-shell"
          "services/pipewire"
          "services/bluetooth"
          "services/power"
          "security"
          "shell/fish"
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
          "boot/kernel/zen"
          "boot-loader/grub"
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
