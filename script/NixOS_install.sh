#! /bin/bash

# qemu script to run nixos
/opt/homebrew/bin/qemu-system-aarch64 \
  -accel hvf \
  -machine virt \
  -cpu host \
  -m 6G \
  -smp 6 \
  -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd \
  -drive if=pflash,format=raw,file=efiVars.fd \
  -cdrom nixos-graphical-25.11.6392.afbbf774e208-aarch64-linux.iso \
  -drive file=nixos.qcow2,if=virtio,format=qcow2 \
  -device qemu-xhci \
  -device usb-kbd \
  -device usb-mouse \
  -device virtio-keyboard-pci \
  -device virtio-mouse-pci \
  -device virtio-gpu \
  -display cocoa
