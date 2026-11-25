# Connectivity info for the VM.
NIXADDR ?= 172.16.67.128
NIXPORT ?= 22
NIXUSER ?= frenzfries
NIXNAME ?= maclaurin

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# A fresh VM changes host keys every install, so don't pin them.
SSH_OPTIONS = -oPubkeyAuthentication=no -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no
SSH = ssh $(SSH_OPTIONS) -p$(NIXPORT)

.PHONY: help
help:
	@echo "On the Mac (NIXADDR=<vm ip>):"
	@echo "  make vm/deploy      vm/copy + vm/switch: push local edits and switch"
	@echo "  make vm/copy        rsync this repo to /nixify in the VM"
	@echo "  make vm/switch      nixos-rebuild switch the VM from /nixify"
	@echo "  make check          evaluate every host without building"

.PHONY: check
check:
	nix flake check --all-systems --no-build
	nix eval --raw ".#nixosConfigurations.base.config.system.build.toplevel.drvPath" >/dev/null || exit 1;
	nix eval --raw ".#nixosConfigurations.lunar.config.system.build.toplevel.drvPath" >/dev/null || exit 1;
	nix eval --raw ".#nixosConfigurations.maclaurin.config.system.build.toplevel.drvPath" >/dev/null || exit 1;
	nix eval --raw ".#nixosConfigurations.seiren.config.system.build.toplevel.drvPath" >/dev/null || exit 1;

.PHONY: vm/check-addr
vm/check-addr:
	@if [ "$(NIXADDR)" = "unset" ]; then echo "error: set NIXADDR=<vm ip>" >&2; exit 1; fi

# Copy this checkout to /nixify in the VM.
.PHONY: vm/copy
vm/copy: vm/check-addr
	rsync -av -e '$(SSH)' --delete \
		--exclude='.git/' \
		--exclude='.gitignore' \
		--exclude='result' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nixify

# Switch the VM to /nixify. Does NOT copy; see vm/deploy.
.PHONY: vm/switch
vm/switch: vm/check-addr
	$(SSH) $(NIXUSER)@$(NIXADDR) "sudo nixos-rebuild switch --flake /nixify#$(NIXNAME)"

.PHONY: vm/deploy
vm/deploy: vm/copy vm/switch
