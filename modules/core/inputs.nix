# Declare tools for use in implementing the dendritic pattern
{ inputs, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  # Define avialable systems
  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
