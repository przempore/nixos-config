# NixOS Configuration

A comprehensive NixOS configuration using Nix Flakes for declarative system and user environment management across multiple machines.

## Quick Start

### Development Environment

Enter the development shell to get all necessary tools (`make`, `nh`, `git`, etc.):

```bash
# Manual activation
nix develop

# Or use Make
make dev

# Automatic activation with direnv
direnv allow
```

### Local Workflow

```bash
# Switch NixOS configuration (nh)
make switch

# Switch home-manager configuration (nh)
make home-switch

# Check flake outputs
make check

# Format Nix files
make fmt

# Run GC for store paths older than 3 days
make gc

# Update flake inputs
make update

# Show all available commands
make help
```

### Deployments (deploy-rs)

```bash
# Deploy to dathomir
make deploy/dathomir

# Deploy to dev-vm
make deploy/dev-vm
```

## VM Development

Set up a development VM for testing configurations. Configure the connection details with environment variables:

```bash
export NIXADDR=192.168.1.100   # VM IP or hostname (no user)
export NIXUSER=przemek         # SSH user after bootstrap (default)
export NIXNAME=dev-vm          # Flake configuration to apply
```

```bash
# Get detailed VM setup instructions
make vm/setup-help

# Quick workflow (after VM setup):
make vm/bootstrap0        # Initial VM setup (uses root@${NIXADDR})

make vm/bootstrap         # Copy repo + apply configuration
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
- **wsl** - Windows Subsystem for Linux configuration

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
