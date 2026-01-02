{
  inputs,
  lib,
  nixify-lib,
  ...
}: let
  inherit (lib) concatLists singleton;
  inherit (lib.modules) importApply;
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
      else if builtins.isAttrs aspect
      then let
        path = aspect.path or (throw "aspect attrs must define `path`");
        features = aspect.features or (throw "aspect attrs must define `features`");
      in
        importApply (aspectPaths + /${path}) features
      else throw "type of aspect must be string or an attrs";
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
          "desktopManager/plasma"
          "displayManager/sddm"
          "gpu/intel-nvidia"
          "localization"
          "nix/settings"
          "nixpkgs"
          "programs/common"
          "programs/firefox"
          "security"
          "services/audio/pipewire"
          "services/bluetooth"
          "services/printing"
          "shell/fish"
          "system/network"
          "virtualization/libvirt_qemu"
        ];
        extraModules = [
          inputs.hjem.nixosModules.default
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
