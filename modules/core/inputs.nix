# Declare tools for use in implementing the dendritic pattern
{ inputs, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  flake-file.description = "nixos-config";

  # Core flake inputs
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    den.url = "github:denful/den";
  };

  # Define avialable systems
  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
