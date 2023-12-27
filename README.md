# nix-config

### home-manager
To run home-manager from this flake:
``` bash
export NIXPKGS_ALLOW_UNFREE=1 && nix build '.?submodules=1#homeConfigurations.przemek.activationPackage' --impure --show-trace && ./result/activate
```

### Install Qt
``` bash
nix run \
--impure github:guibou/nixGL \
--override-input nixpkgs nixpkgs/nixos-unstable \
-- nix run github:thiagokokada/nix-alien \
-- -l libGL.so.1 -l libz.so.1 \
~/Downloads/qt-unified-linux-x64-4.6.0-online.run \
--email <EMAIL> \
--password <PASSWORD> \
install \
--no-save-account \
--accept-messages \
--accept-licenses \
--accept-obligations 
--confirm-command \
--no-default-installations \
--no-force-installations \
--root ~/Qt qt.qt5.51514.gcc_64
```

[source: Method 9\) nix-alien](https://unix.stackexchange.com/a/522823)


### `.deb` installation in NixOS
[source](https://reflexivereflection.com/posts/2015-02-28-deb-installation-nixos.html)

## Installation
```bash
sudo nixos-rebuild switch --flake .#nixos
```

## Flakes Book
[NixSO & Flakes Book](https://nixos-and-flakes.thiscute.world/)

## devenv
[source](https://devenv.sh/getting-started/)

`nix flake init --template github:cachix/devenv`

[broken symbolic links](https://github.com/NixOS/nix/issues/7166) <br/>
use this command to remove them: <br/>
`find -L /nix/var/nix/gcroots/per-user/$USER -maxdepth 1 -type l -delete`

## Flake templates
[github flake template](https://github.com/NixOS/templates)

`nix flake init --template templates#full`
