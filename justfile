# NixOS configuration tasks.
# Run `just --list` to see available recipes.

set shell := ["bash", "-cu"]

NIXADDR := env_var_or_default("NIXADDR", "dev-vm")
NIXUSER := env_var_or_default("NIXUSER", "przemek")
NIXNAME := env_var_or_default("NIXNAME", "dev-vm")
HOSTNAME := `hostname`
SSH_OPTIONS := "-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

help:
    @just --list

# Switch NixOS configuration on the local system.
switch:
    sudo -v
    nh os switch '.?submodules=1' -- --impure --show-trace

# Switch Home Manager configuration on the local system.
home-switch:
    nh home switch --configuration {{HOSTNAME}} '.?submodules=1' -- --impure

# Build the NixOS configuration on the local system.
build:
    nh os build '.?submodules=1' -- --impure --show-trace

# Update flake inputs.
update:
    git fetch --all && git rebase && git submodule update --init
    nix flake update --commit-lock-file

# Check flake configuration.
check:
    nix flake check

# Deploy to dathomir via deploy-rs.
deploy-dathomir:
    deploy .#dathomir -- --show-trace

# Deploy to dev-vm via deploy-rs.
deploy-dev-vm:
    deploy .#dev-vm -- --show-trace

# Deploy to dooku via deploy-rs.
deploy-dooku:
    deploy .#dooku -- --show-trace

# Deploy to dooku via deploy-rs using the local target.
deploy-dooku-local:
    deploy .#dooku_local -- --show-trace

alias gc := garbage-collection

# Run Nix store garbage collection for paths older than three days.
garbage-collection:
    @echo "Running Nix GC (deleting paths older than 3d)..."
    sudo nix-collect-garbage --delete-older-than 3d

# Build the WSL root filesystem installer tarball.
wsl:
    nix build ".?submodules=1#nixosConfigurations.wsl.config.system.build.tarballBuilder" && \
        sudo result/bin/nixos-wsl-tarball-builder

# Bootstrap a new VM, step 1: prepare the system.
vm-bootstrap0:
    ssh {{SSH_OPTIONS}} root@{{NIXADDR}} " \
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
        sed --in-place '/system\\.stateVersion = .*/a\\n  nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];' /mnt/etc/nixos/configuration.nix && \
        nixos-install --no-root-passwd && \
        reboot"
    @echo "VM bootstrap0 complete. Reboot, then run 'just vm/bootstrap'."

# Bootstrap a new VM, step 2: apply the configuration.
vm-bootstrap: vm-copy vm-secrets
    ssh {{SSH_OPTIONS}} {{NIXUSER}}@{{NIXADDR}} " \
        sudo nixos-rebuild switch --flake '.?submodules=1#{{NIXNAME}}' --show-trace --impure"
    @echo "VM bootstrap complete. You may want to reboot the VM."

# Copy configuration files to the VM.
vm-copy:
    rsync -av -e 'ssh {{SSH_OPTIONS}}' \
        --exclude='result*' \
        --exclude='.git/' \
        --exclude='hosts/*/home/.config' \
        . {{NIXUSER}}@{{NIXADDR}}:nixos-config/

# Copy secrets to the VM. Add provisioning here when needed.
vm-secrets:
    @echo "Copying secrets to VM..."
    @echo "No secret-copying steps are configured."

# Rebuild and switch the VM configuration.
vm-switch: vm-copy
    ssh {{SSH_OPTIONS}} {{NIXUSER}}@{{NIXADDR}} " \
        cd nixos-config && \
        sudo nixos-rebuild switch --flake '.?submodules=1#{{NIXNAME}}' --show-trace --impure"

# Switch Home Manager configuration on the VM.
vm-home-switch: vm-copy
    ssh {{SSH_OPTIONS}} {{NIXUSER}}@{{NIXADDR}} " \
        cd nixos-config && \
        nix run '.?submodules=1#homeConfigurations.{{HOSTNAME}}.activationPackage' --show-trace --impure -- switch"

# SSH into the VM.
vm-ssh:
    ssh {{SSH_OPTIONS}} {{NIXUSER}}@{{NIXADDR}}

# Reboot the VM.
vm-reboot:
    ssh {{SSH_OPTIONS}} {{NIXUSER}}@{{NIXADDR}} "sudo reboot"

# Generate hardware configuration for the current system.
install-generate-config:
    sudo nixos-generate-config --show-hardware-config

# Install NixOS on a fresh system from a NixOS ISO.
install-fresh:
    @echo "This will install NixOS with this configuration on the current system."
    @echo "Make sure the root, boot, and swap partitions are labeled nixos, boot, and swap."
    @echo "Make sure the root filesystem is mounted at /mnt and boot at /mnt/boot."
    @read -r -p "Continue? [y/N] " confirm && [ "$$confirm" = "y" ]
    nixos-generate-config --root /mnt
    cp -r . /mnt/etc/nixos/
    nixos-install --flake '/mnt/etc/nixos#{{NIXNAME}}' --no-root-passwd

# Format Nix files.
fmt:
    nixpkgs-fmt .

# Clean Nix build artifacts.
clean:
    rm -rf result result-*

# Enter the development environment.
dev:
    nix develop

# Show development environment information.
dev-info:
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
    @echo "  - make, git, ssh, rsync"
    @echo "  - nh, nixpkgs-fmt, nil, nix-tree, nom"
    @echo "  - Network tools for VM management"

# Show VM setup instructions.
vm-setup-help:
    @echo "VM Setup Instructions"
    @echo "===================="
    @echo ""
    @echo "OVERVIEW:"
    @echo "- Justfile runs on the host machine where this repo is cloned."
    @echo "- Commands SSH into the VM to perform operations."
    @echo "- The VM starts from a NixOS ISO and is configured remotely."
    @echo ""
    @echo "STEP 1: Create a VM with at least 150GB disk, 4GB RAM, multiple CPUs, network access, and graphics acceleration."
    @echo "STEP 2: Boot a NixOS ISO. Download from https://nixos.org/download.html"
    @echo "STEP 3: Set a temporary root password in the VM and find its IP address."
    @echo "STEP 4: Set NIXADDR=root@YOUR_VM_IP and NIXNAME=dev-vm on the host."
    @echo "STEP 5: Run 'just vm/bootstrap0', then after reboot run 'just vm/bootstrap'."
    @echo "STEP 6: Use 'just vm/switch', 'just vm/ssh', and 'just vm/home-switch'."
    @echo ""
    @echo "TROUBLESHOOTING:"
    @echo "- If SSH fails, check the VM IP, firewall, and SSH service."
    @echo "- If bootstrap0 fails, ensure the VM has internet access."
    @echo "- For VirtualBox, enable virtualisation.virtualbox.guest.enable manually."
