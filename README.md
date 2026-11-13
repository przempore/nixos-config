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

### Codex history and recall (Hansard)

The common Home Manager configuration installs a pinned Hansard package and
starts `hansard.service` at login. On first start it creates a local archive,
watches Codex CLI/ACP sessions, and installs Hansard's MCP server, hooks, and
recall skills in Codex's existing writable configuration. The watcher uses
Hansard's default 30-day look-back window; already archived sessions remain
available. Later service starts refresh the integration after package upgrades.

After applying Home Manager, start a new Codex session in Emacs agent-shell.
Ask it to recall an earlier decision, or use `$recall <topic>` and
`$recall-memories <topic>`. The Emacs service already includes the user profile
on its PATH, and codex-acp uses the same Codex configuration and session store.

```bash
systemctl --user status hansard
hansard integrations status
hansard web
```

The archive and mutable settings live under `~/.hansard`. Home Manager owns
login startup, so use `systemctl --user restart hansard` after configuration
changes rather than `hansard watcher login enable`. Windows/work history and
other machines remain separate unless Personal Sync is explicitly configured.

### Deployments (deploy-rs)

```bash
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

## Machine Configurations

This flake supports multiple machines:

- **ilum** - Gaming desktop
- **dathomir** - Dell laptop  
- **dooku** - Lenovo ThinkPad
- **dev-vm** - Development VM (universal: QEMU/KVM, Hyper-V, VirtualBox)

Machine settings are kept in `lib/machines.nix`. To add a machine:

1. Add `hosts/<name>/configuration.nix` and `hosts/<name>/home/default.nix`.
2. Add one entry to `lib/machines.nix` with its `user` and optional hardware, feature, or deployment settings.
3. Run `nix flake check`.

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
- `lib/machines.nix` - Machine registry used to generate flake outputs
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
