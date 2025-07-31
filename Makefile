# NixOS Configuration Makefile
# Inspired by Mitchell Hashimoto's nixos-config

# VM Configuration
NIXADDR ?= nixos@192.168.1.100
NIXNAME ?= dev-vm
NIXUSER ?= przemek
HOSTNAME := $(shell hostname)

# SSH options for VM access
SSH_OPTIONS := -o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY: help
help: ## Show this help message
	@echo "NixOS Configuration Management"
	@echo "==============================="
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

##
## Local System Management
##

.PHONY: switch
switch: ## Switch NixOS configuration on local system
	nh os switch '.?submodules=1' -- --impure --show-trace

.PHONY: home-switch
home-switch: ## Switch home-manager configuration on local system
	nh home switch --configuration $(HOSTNAME) '.?submodules=1' -- --impure

.PHONY: update
update: ## Update flake inputs
	git fetch --all && git rebase && git submodule update --init
	nix flake update --commit-lock-file
	git push

.PHONY: check
check: ## Check flake configuration
	nix flake check

.PHONY: deploy
deploy: ## Deploy to remote system using deploy-rs (requires devShell)
	deploy --targets .#dathomir

.PHONY: deploy-local
deploy-local: ## Deploy locally without remote dependencies
	deploy --targets .#dathomir --local-sudo

.PHONY: gc garbage-collection
gc: garbage-collection

garbage-collection:
	@echo "🗑️  Running Nix GC (deleting paths >3d old)…"
	sudo nix-collect-garbage --delete-older-than 3d

##
## WSL
##

.PHONY: wsl
wsl: ## Build the WSL root-fs installer tarball
	nix build ".?submodules=1#nixosConfigurations.wsl.config.system.build.tarballBuilder" && \
	sudo result/bin/nixos-wsl-tarball-builder;

##
## VM Management
##

.PHONY: vm/bootstrap0
vm/bootstrap0: ## Bootstrap new VM (step 1: prepare system)
	ssh $(SSH_OPTIONS) root@$(NIXADDR) " \
		parted /dev/sda -- mklabel gpt && \
		parted /dev/sda -- mkpart root ext4 512MB -8GB && \
		parted /dev/sda -- mkpart swap linux-swap -8GB 100% && \
		parted /dev/sda -- mkpart ESP fat32 1MB 512MB && \
		parted /dev/sda -- set 3 esp on && \
		sleep 1 && \
		mkfs.ext4 -L nixos /dev/sda1 && \
		mkswap -L swap /dev/sda2 && \
		mkfs.fat -F 32 -n boot /dev/sda3 && \
		mount /dev/disk/by-label/nixos /mnt && \
		mkdir -p /mnt/boot && \
		mount /dev/disk/by-label/boot /mnt/boot && \
		nixos-generate-config --root /mnt && \
		sed --in-place '/system\.stateVersion = .*/a\\n  nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];' /mnt/etc/nixos/configuration.nix && \
		nixos-install --no-root-passwd && \
		reboot"
	@echo "VM bootstrap0 complete. Reboot and then run 'make vm/bootstrap' to apply your configuration."

.PHONY: vm/bootstrap
vm/bootstrap: vm/copy vm/secrets ## Bootstrap new VM (step 2: apply configuration)
	ssh $(SSH_OPTIONS) $(NIXADDR) " \
		sudo nixos-rebuild switch --flake '.?submodules=1#$(NIXNAME)' --show-trace --impure"
	@echo "VM bootstrap complete. You may want to reboot the VM."

.PHONY: vm/copy
vm/copy: ## Copy configuration files to VM
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='result*' \
		--exclude='.git/' \
		--exclude='hosts/*/home/.config' \
		. $(NIXADDR):nixos-config/

.PHONY: vm/secrets
vm/secrets: ## Copy secrets to VM (implement as needed)
	@echo "Copying secrets to VM..."
	@# Add your secret copying logic here
	@# Example: rsync SSH keys, GPG keys, etc.

.PHONY: vm/switch
vm/switch: vm/copy ## Rebuild and switch VM configuration
	ssh $(SSH_OPTIONS) $(NIXADDR) " \
		cd nixos-config && \
		sudo nixos-rebuild switch --flake '.?submodules=1#$(NIXNAME)' --show-trace --impure"

.PHONY: vm/home-switch
vm/home-switch: vm/copy ## Switch home-manager configuration on VM
	ssh $(SSH_OPTIONS) $(NIXADDR) " \
		cd nixos-config && \
		nix run '.?submodules=1#homeConfigurations.$(HOSTNAME).activationPackage' --show-trace --impure -- switch
		# nh home switch --backup-extension backup_$$(date +\"%Y%M%H%M%S\") '.?submodules=1' -- --show-trace --impure"

.PHONY: vm/ssh
vm/ssh: ## SSH into the VM
	ssh $(SSH_OPTIONS) $(NIXADDR)

.PHONY: vm/reboot
vm/reboot: ## Reboot the VM
	ssh $(SSH_OPTIONS) $(NIXADDR) "sudo reboot"

##
## Fresh Installation Helpers
##

.PHONY: install/generate-config
install/generate-config: ## Generate hardware configuration for current system
	sudo nixos-generate-config --show-hardware-config

.PHONY: install/fresh
install/fresh: ## Install NixOS on fresh system (run from NixOS ISO)
	@echo "This will install NixOS with this configuration on the current system."
	@echo "Make sure you have:"
	@echo "  1. Partitioned your disk with labeled partitions:"
	@echo "     - Root partition labeled 'nixos'"
	@echo "     - Boot partition labeled 'boot'"  
	@echo "     - Swap partition labeled 'swap'"
	@echo "  2. Mounted root filesystem to /mnt"
	@echo "  3. Mounted boot filesystem to /mnt/boot"
	@echo ""
	@read -p "Continue? [y/N] " confirm && [ "$$confirm" = "y" ]
	nixos-generate-config --root /mnt
	cp -r . /mnt/etc/nixos/
	nixos-install --flake '/mnt/etc/nixos#$(NIXNAME)' --no-root-passwd

##
## Development Tools
##

.PHONY: fmt
fmt: ## Format Nix files
	nixpkgs-fmt .

.PHONY: clean
clean: ## Clean build artifacts
	rm -rf result result-*

.PHONY: dev
dev: ## Enter development environment (nix develop)
	nix develop

.PHONY: dev-info
dev-info: ## Show development environment information
	@echo "Development Environment Setup"
	@echo "============================="
	@echo ""
	@echo "Option 1: Manual activation"
	@echo "  nix develop"
	@echo ""
	@echo "Option 2: direnv (Auto-activation)"
	@echo "  direnv allow"
	@echo ""
	@echo "This provides:"
	@echo "  - make (GNU Make)"
	@echo "  - git, ssh, rsync"
	@echo "  - nh (Nix helper)"
	@echo "  - nixpkgs-fmt, nil, nix-tree, nom"
	@echo "  - Network tools for VM management"

##
## Documentation
##

.PHONY: vm/setup-help
vm/setup-help: ## Show VM setup instructions
	@echo "VM Setup Instructions"
	@echo "===================="
	@echo ""
	@echo "OVERVIEW:"
	@echo "- Makefile runs on HOST machine (where this repo is cloned)"
	@echo "- Commands SSH into VM to perform operations"
	@echo "- VM starts with NixOS ISO, gets configured remotely"
	@echo ""
	@echo "STEP 1: Create VM on your hypervisor"
	@echo "   - 150GB+ disk space"
	@echo "   - 4GB+ RAM"
	@echo "   - Multiple CPU cores"
	@echo "   - Network access (bridged or NAT with port forwarding)"
	@echo "   - Enable graphics acceleration for bspwm GUI"
	@echo ""
	@echo "STEP 2: Boot NixOS ISO in the VM"
	@echo "   Download from: https://nixos.org/download.html"
	@echo ""
	@echo "STEP 3: Configure VM for remote access (RUN IN VM)"
	@echo "   sudo passwd root                    # Set root password"
	@echo "   ip addr show                        # Find VM IP address"
	@echo ""
	@echo "STEP 4: Configure host environment (RUN ON HOST)"
	@echo "   export NIXADDR=root@YOUR_VM_IP      # Replace with actual VM IP"
	@echo "   export NIXNAME=dev-vm               # Configuration name"
	@echo "   cd /path/to/nixos-config            # This repository"
	@echo ""
	@echo "STEP 5: Bootstrap VM (RUN ON HOST)"
	@echo "   make vm/bootstrap0                  # Partition, format, install base"
	@echo "   # VM will reboot automatically"
	@echo "   export NIXADDR=przemek@YOUR_VM_IP   # After reboot, use user account"
	@echo "   make vm/bootstrap                   # Apply your configuration"
	@echo ""
	@echo "STEP 6: Daily development (RUN ON HOST)"
	@echo "   make vm/switch                      # Deploy config changes"
	@echo "   make vm/ssh                         # SSH into VM"
	@echo "   make vm/home-switch                 # Update home-manager"
	@echo ""
	@echo "TROUBLESHOOTING:"
	@echo "- If SSH fails: Check VM IP, firewall, SSH service"
	@echo "- If bootstrap0 fails: Ensure VM has internet access"
	@echo "- For VirtualBox: Enable 'virtualisation.virtualbox.guest.enable = true;'"
	@echo ""
	@echo "VM Configuration Notes:"
	@echo "- Universal hardware config supporting:"
	@echo "  * QEMU/KVM (Linux hosts)"
	@echo "  * Hyper-V (Windows hosts) - RECOMMENDED for Windows"
	@echo "  * VirtualBox (optional, enable guest additions manually)"
	@echo "- Uses bspwm for lightweight GUI performance"
	@echo "- Auto-login enabled for easier development"
