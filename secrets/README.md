Secrets with sops-nix
=====================

This repository wires secrets using sops-nix. OpenVPN now reads its username/password from a file decrypted at runtime in `/run/secrets` instead of environment variables.

What’s wired
------------
- Secret name: `openvpn/office-auth`
- Expected content: two lines (no trailing spaces)
  - Line 1: username
  - Line 2: password
- Service usage: `auth-user-pass /run/secrets/openvpn/office-auth`

Setup steps
-----------
1) Install sops and age on your workstation (outside of NixOS build):
   - Nix: `nix shell nixpkgs#sops nixpkgs#age`

2) Generate an age key on each NixOS host (or let sops-nix do it):
   - This config sets `sops.age.generateKey = true`, which creates `/var/lib/sops-nix/key.txt` automatically on first activation.
   - Get the host public key: `sudo cat /var/lib/sops-nix/key.txt | age-keygen -y`

3) Configure sops recipient(s):
   - Add your age recipient(s) to `.sops.yaml` under `creation_rules`.

4) Create the encrypted secrets file at `secrets/secrets.yaml`:
   - Create plaintext template (do not commit):
     ```
     openvpn_office_auth: |
       YOUR_USERNAME
       YOUR_PASSWORD
     ```
   - Encrypt in-place using sops (this produces an encrypted YAML you can commit):
     `sops --encrypt --in-place secrets/secrets.yaml`

5) Deploy/switch:
   - `sudo nixos-rebuild switch --flake .#<host>` (or your usual workflow)
   - On first activation, sops-nix will place the file at `/run/secrets/openvpn/office-auth` for OpenVPN to use.

Notes
-----
- Do NOT commit plaintext secrets. Only commit the sops-encrypted `secrets/secrets.yaml`.
- You can store multiple secrets in the same file; this configuration specifically expects the key `openvpn_office_auth`.
- If you need different creds per host, either use per-host sops files or per-host keys and files.

