# Gaming on dooku

`gaming.nix` provides Steam, Lutris, GameMode, and MangoHud. Install and manage
Wine runners through Lutris. The existing hardware configuration already
enables Intel graphics and 32-bit graphics libraries.

Apply the configuration on dooku from the repository root:

```sh
sudo nixos-rebuild switch --flake '.?submodules=1#dooku'
```

Log out and back in to pick up the `gamemode` group, then run `gamemoded -t`
to check GameMode.

## Battle.net and World of Warcraft

Use Lutris to install Battle.net, then install World of Warcraft through
Battle.net. The launcher and games live in a user-managed Wine prefix,
separately from the NixOS configuration.

1. Open Lutris and install Battle.net through its installer.
2. Keep the Wine runner and prefix selected by that installer.
3. Launch Battle.net from Lutris, sign in, and install World of Warcraft.
   Use the same launcher to manage your other Battle.net games.
4. Enable GameMode in the Lutris entry's **System options**. MangoHud is
   available there as an optional performance overlay.

For Steam games, use `gamemoderun %command%` in the game's launch options to
request GameMode. Add `mangohud` after `gamemoderun` to enable the overlay.

## Keyboard layouts in Wine games

Click the bar's keyboard layout indicator or press **Super+Ctrl+K** to switch
between custom Dvorak and US QWERTY. The toggle puts the selected layout first
in the keymap and activates it, changing the base layout exposed to Wine as
well as the layout used for typing. Dvorak remains the default on login.

Select **EN** for gaming and **DV** to return to Dvorak. If WoW still uses its
previous movement keys, fully exit WoW and Battle.net and relaunch them with
**EN** selected so Wine can pick up the new keymap.
