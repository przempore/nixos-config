{ pkgs }:

pkgs.writeShellApplication {
name = "sentinel";
text = ''
  #!/usr/bin/env sh
  echo "Hello from my application!"
'';
}
