{ config, lib, ... }:

let
  pkgs = import <nixpkgs> { };
  nixos-hardware = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-hardware";
    rev = "bee2202bec57e521e3bd8acd526884b9767d7fa0";
    sha256 = "sha256-rd+dY+v61Y8w3u9bukO/hB55Xl4wXv4/yC8rCGVnK5U=";
  };
in
{
  imports = [
    (nixos-hardware + "/common/pc/laptop")
  ];
}

