# NixOS Configuration

A comprehensive NixOS configuration using Nix Flakes for declarative system and user environment management across multiple machines.

## Quick Start

### 1. Development Environment

Enter the development shell to get all necessary tools (`make`, `nh`, `git`, etc.):

```bash
# Option 1: Manual activation
nix develop

# Option 2: Automatic with direnv
direnv allow
```

### 2. Local System Management

```bash
# Switch NixOS configuration
make switch

# Switch home-manager configuration  
make home-switch

# Update flake inputs
make update

# Show all available commands
make help
```

## VM Development

Set up a development VM for testing configurations:

```bash
# Get detailed VM setup instructions
make vm/setup-help

# Quick workflow (after VM setup):
export NIXADDR=root@VM_IP
make vm/bootstrap0        # Initial VM setup

export NIXADDR=przemek@VM_IP  
make vm/bootstrap         # Apply configuration
make vm/switch            # Deploy changes
```

## WSL

Build and install NixOS WSL distribution with CLI tools from dev-vm configuration:

### Building WSL Tarball

```bash
make wsl
```

This creates a WSL distribution tarball builder. To generate the actual tarball:

```bash
sudo result/bin/nixos-wsl-tarball-builder
```

This produces a `nixos.wsl` file ready for Windows installation.

### Installing on Windows

1. **Transfer the tarball**: Copy `nixos.wsl` to your Windows machine

2. **Install WSL distribution** (run in PowerShell as Administrator):
   ```powershell
   wsl --import NixOS C:\WSL\NixOS C:\path\to\nixos.wsl
   ```

3. **Set as default** (optional):
   ```powershell
   wsl --set-default NixOS
   ```

4. **Launch NixOS WSL**:
   ```powershell
   wsl -d NixOS
   ```

### WSL Management

- **List distributions**: `wsl --list --verbose`
- **Stop distribution**: `wsl --terminate NixOS`
- **Uninstall**: `wsl --unregister NixOS`
- **Update**: Rebuild tarball and re-import

### What's Included

The WSL configuration includes CLI development tools from dev-vm:
- Modern shell (Fish with completions)
- Development tools (git, nvim, tmux, fzf, ripgrep, etc.)
- Programming languages (Node.js, Python 3)
- Container tools (docker-compose)
- Network utilities (SSH, Tailscale)
- Nix package manager with flakes enabled

## Machine Configurations

This flake supports multiple machines:

- **ilum** - Gaming desktop
- **dathomir** - Dell laptop  
- **dooku** - Lenovo ThinkPad
- **dev-vm** - Development VM (universal: QEMU/KVM, Hyper-V, VirtualBox)

## Architecture

- **Modular design** - Shared configuration with host-specific overrides
- **Multiple nixpkgs channels** - Stable, unstable, and legacy for compatibility
- **Universal VM support** - Works across different hypervisors
- **Makefile automation** - Simple commands for all operations

## Key Features

- **bspwm/Hyprland** desktop environments
- **Comprehensive app configurations** (Neovim, Firefox, development tools)
- **VM-optimized** configurations for development
- **Remote deployment** with deploy-rs
- **Automatic formatting** and development tools

## Resources

- **[NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)** - Comprehensive guide
- **[devenv](https://devenv.sh/getting-started/)** - Development environments  
- **[Flake templates](https://github.com/NixOS/templates)** - Starting templates

## Files

- `flake.nix` - Main flake configuration
- `lib/mkSystem.nix` - System configuration factory
- `hosts/` - Machine-specific configurations
- `Makefile` - Development workflow automation
- `CLAUDE.md` - Claude Code assistant reference

## Troubleshooting

```bash
# Check configuration syntax
make check

# Format Nix files
make fmt

# Clean broken symbolic links
find -L /nix/var/nix/gcroots/per-user/$USER -maxdepth 1 -type l -delete
```