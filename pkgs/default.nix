{ pkgs, ... }:
let
  theme = import ../theme.nix;
  inherit (pkgs) callPackage;
in
{
  hypr = callPackage ./hypr { inherit theme; };
}
