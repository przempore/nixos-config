# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive NixOS configuration repository using Nix Flakes for declarative system and user environment management across multiple machines (ilum, dathomir, dooku, dev-vm, wsl). The architecture is modular with shared configurations and host-specific overrides.

## Common Commands

### Makefile-based Development Workflow
```bash
# Show all available commands
make help

# Local system management
make switch           # Switch NixOS configuration
make home-switch      # Switch home-manager configuration
make update           # Update flake inputs
make check            # Check flake configuration
make deploy           # Deploy to remote systems (dathomir)
make deploy-local     # Deploy locally with sudo

# VM development workflow
make vm/setup-help    # Show VM setup instructions
make vm/bootstrap0    # Bootstrap new VM (step 1: prepare system)
make vm/bootstrap     # Bootstrap new VM (step 2: apply configuration)
make vm/switch        # Rebuild and switch VM configuration
make vm/home-switch   # Switch home-manager on VM
make vm/ssh           # SSH into the VM
make vm/reboot        # Reboot the VM

# Fresh installation
make install/fresh    # Install NixOS on fresh system
make install/generate-config  # Generate hardware configuration

# WSL
make wsl               # Build WSL root-fs installer tarball

# Maintenance
make gc                # Run garbage collection (delete paths >3d old)
make fmt               # Format Nix files
make clean             # Clean build artifacts
```

### Traditional Commands (alternative to Makefile)
```bash
# Switch NixOS system configuration (using nh)
nh os switch --update '.?submodules=1' -- --impure --show-trace

# Switch home-manager configuration (using nix run for better hostname detection)
nix run '.?submodules=1#homeConfigurations.$(hostname).activationPackage' --show-trace --impure -- switch --backup-extension backup_$(date +"%Y%M%H%M%S")

# Traditional NixOS rebuild
sudo nixos-rebuild switch --flake '.?submodules=1#<host_name>' --show-trace --impure

# Traditional home-manager activation
nix run '.?submodules=1#homeConfigurations.<configuration>.activationPackage' --show-trace --impure -- switch
```

### Development Environment

#### Using the flake devShell (Recommended)
```bash
# Enter development shell (provides make, git, ssh, etc.)
nix develop

# Or use direnv for automatic shell activation
direnv allow

# Available tools:
make               # GNU Make for running Makefile commands
nixpkgs-fmt        # Format Nix files
nh                 # Fast NixOS rebuilds (moved from global)
nix-tree           # Explore dependency tree
nom                # Better nix build output (moved from global)
deploy-rs          # Remote NixOS deployments
nil                # Nix LSP for editors (moved from global nvim)
netcat, nmap       # Network tools for VM management
inetutils          # Network utilities for remote operations
```

#### Manual setup
```bash
# Clean broken symbolic links
find -L /nix/var/nix/gcroots/per-user/$USER -maxdepth 1 -type l -delete
```

## Architecture Overview

### Core Structure
- **`flake.nix`**: Central configuration defining inputs and outputs for all machines
- **`lib/mkSystem.nix`**: Factory function creating both NixOS and home-manager configurations
- **`hosts/common/`**: Shared configuration across all machines
- **`hosts/{ilum,dathomir,dooku,dev-vm,wsl}/`**: Host-specific configurations
- **`Makefile`**: Development workflow automation for system management and VM operations

### Key Components

#### Multi-Machine Configuration System
The repository uses a custom `mkSystem` function that creates configurations for both NixOS and home-manager simultaneously. Each host defines:
- Hardware-specific modules via nixos-hardware
- User assignments (przemek, porebski) with role-based configurations
- Machine-specific overrides for the shared base configuration

#### Package Management Strategy
- **Multiple Nixpkgs Channels**: Stable (25.05), unstable, and legacy (24.05) for compatibility
- **Unfree Package Allowlist**: Explicit control over proprietary software in `hosts/common/configuration.nix`
- **Overlay System**: Custom overlays for packages like deploy-rs

#### Application Configuration Architecture
- **Modular Apps**: Each application configured in separate files under `hosts/common/home/apps/`
- **Desktop Environments**: Multiple DE/WM support (BSPWM, Hyprland, XFCE) with conditional loading
- **Modern Applications**: Includes Ghostty terminal, Superfile file manager, Zathura PDF viewer, Ansible automation
- **Shared vs Private**: Clear separation between common configs and personal/work-specific settings in `hosts/common/home/private/`

### External Dependencies Management
The configuration integrates multiple external flakes including:
- **catppuccin**: Consistent theming across applications
- **zen-browser**, **ghostty**: Modern application alternatives
- **lix-module**: Alternative Nix implementation (version 2.93.0)
- **neovim-nightly**: Latest editor features
- **tmux-sessionx**: Enhanced tmux session management
- **nixai**: AI assistant integration
- **nixos-wsl**: WSL support for NixOS

## Development Guidelines

### Configuration Changes
- Always test changes on non-critical hosts first
- Use `--show-trace` flag for debugging configuration issues
- Follow the existing modular pattern: separate files for each application/service
- Hardware-specific changes should be isolated to host-specific directories

### VM Development Workflow
- **Makefile runs on HOST machine** (where this repo is cloned)
- **Commands SSH into VM** to perform operations remotely
- Use `make vm/setup-help` for detailed step-by-step setup instructions
- The dev-vm configuration uses bspwm for lightweight GUI performance in VMs
- Similar to dathomir setup but optimized for VM usage with reduced effects
- **XRDP Support**: Remote Desktop Protocol for GUI access to VMs (work in progress)
- Universal VM hardware configuration supporting multiple hypervisors:
  - QEMU/KVM (Linux hosts)
  - Hyper-V (Windows hosts) - recommended for Windows with enhanced kernel modules
  - VirtualBox (optional, guest additions disabled by default)
- Hardware config is version controlled and works across VM platforms
- Test configuration changes in VM before applying to physical machines

#### Quick VM Workflow:
1. **On HOST**: `export NIXADDR=root@VM_IP && make vm/bootstrap0`
2. **On HOST**: `export NIXADDR=przemek@VM_IP && make vm/bootstrap`
3. **Daily**: `make vm/switch` (deploy changes), `make vm/ssh` (access VM)

### WSL Development Workflow
- **Build WSL tarball**: `make wsl` creates the WSL distribution tarball
- **CLI-focused**: WSL configuration includes only CLI applications from dev-vm (no GUI)
- **Lightweight**: Optimized for Windows WSL environment with essential development tools

#### Installing WSL Tarball on Windows:
1. **Build the tarball**: Run `make wsl` to create the WSL distribution
2. **Run tarball builder**: Execute `sudo result/bin/nixos-wsl-tarball-builder` to generate `nixos.wsl` file
3. **Transfer to Windows**: Copy the `nixos.wsl` file to your Windows machine
4. **Install WSL distribution**:
   ```powershell
   # Open PowerShell as Administrator
   wsl --import NixOS C:\WSL\NixOS C:\path\to\nixos.wsl
   ```
5. **Set as default** (optional):
   ```powershell
   wsl --set-default NixOS
   ```
6. **Launch NixOS WSL**:
   ```powershell
   wsl -d NixOS
   ```

#### WSL Management Commands:
- **List distributions**: `wsl --list --verbose`
- **Stop distribution**: `wsl --terminate NixOS`
- **Uninstall**: `wsl --unregister NixOS`
- **Update**: Rebuild tarball and re-import

#### First Boot Experience:
- Automatically logged in as `przemek` user
- Fish shell with completion and syntax highlighting
- All CLI development tools available (git, nvim, tmux, fzf, etc.)
- Nix package manager with flakes enabled
- SSH and Tailscale services ready

### Secret Management
- API keys and credentials are currently in private configurations
- Consider migrating to sops-nix or agenix for better secret management
- Never commit sensitive information to the repository

### Backup Strategy
- The existing backup system in home-manager switches creates timestamped backups
- Always use the backup extension when switching configurations

## Key Files to Understand

- **`flake.nix`**: Input management and system output definitions
- **`lib/mkSystem.nix`**: Configuration factory function logic
- **`hosts/common/configuration.nix`**: Base NixOS system configuration and package allowlists
- **`hosts/common/home/default.nix`**: Base home-manager configuration structure
- **`hosts/common/home/desktop/`**: Desktop environment configurations (bspwm, gtk, screen settings)
- **`hosts/common/home/apps/nvim/`**: Extensive Neovim configuration with Lua customizations
- **`hosts/common/home/apps/ghostty/`**: Modern terminal emulator with CSS styling and keybindings
- **`hosts/common/home/apps/superfile/`**: Vim-style file manager configuration
- **`hosts/common/hyprland.nix`**: Wayland compositor configuration
- **`hosts/dev-vm/`**: VM-optimized configuration using bspwm for lightweight GUI
- **`hosts/wsl/`**: WSL-specific NixOS configuration with CLI tools optimized for Windows WSL
- **`hosts/common/home/private/`**: Personal configurations and sensitive data (not tracked)
- **`hosts/common/home/apps/`**: Application-specific configurations (nvim, firefox, ghostty, etc.)
- **`Makefile`**: Development workflow automation for system and VM management

## Testing and Validation

When making changes:
1. Test configuration syntax with `nix flake check`
2. Use `--show-trace` for detailed error information
3. Test on less critical hosts before applying to main machines
4. Verify hardware-specific configurations don't break other hosts

## Development Workflow Best Practices

### Making Configuration Changes
1. **Enter development shell**: `nix develop` or `direnv allow`
2. **Test syntax**: `make check` before applying changes
3. **Format code**: `make fmt` to maintain consistent formatting
4. **Test in VM**: Use `make vm/switch` to test changes safely
5. **Apply locally**: Use `make switch` and `make home-switch` for local changes
6. **Deploy remotely**: Use `make deploy` for remote systems

### Working with Multiple Hosts
- Each host has its own configuration in `hosts/<hostname>/`
- The `mkSystem` function in `lib/mkSystem.nix` creates both NixOS and home-manager configurations
- Common configurations are shared through `hosts/common/`
- Hardware-specific modules are defined per host using nixos-hardware

### Package Management
- **Stable packages**: Use main nixpkgs channel (25.05)
- **Bleeding edge**: Use nixpkgs-unstable for latest packages
- **Legacy compatibility**: Use legacy-nixpkgs (24.05) for older software
- **Unfree packages**: Must be explicitly allowed in `hosts/common/configuration.nix`