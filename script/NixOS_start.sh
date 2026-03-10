#! /bin/bash

# qemu script to run nixos
# NOTE: vmnet-shared requires sudo for macOS virtual networking
/opt/homebrew/bin/qemu-system-aarch64 \
  -accel hvf \
  -machine virt,highmem=on \
  -cpu host \
  -m 4096 \
  -smp 6 \
  -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd \
  -drive if=pflash,format=raw,file=efiVars.fd \
  -drive file=nixos.qcow2,if=virtio,format=qcow2,cache=writethrough,discard=unmap,detect-zeroes=unmap \
  -device qemu-xhci \
  -device usb-kbd \
  -device virtio-keyboard-pci \
  -device virtio-mouse-pci \
  -device virtio-gpu \
  -display cocoa \
  -device virtio-net-pci,netdev=net0 \
  -netdev vmnet-shared,id=net0 \
  -device virtio-rng-pci \
  -device virtio-balloon-pci
