# Declare tools for use in implementing the dendritic pattern
{ inputs, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  # Flake inputs
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/26.05";
    flake-file.url = "github:vic/flake-file";
    den.url = "github:denful/den";
  };

  # Define avialable systems
  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
