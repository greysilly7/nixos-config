{
  inputs,
  den,
  lib,
  ...
}:
{
  # Flake inputs
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Include disko by default in all hosts
  den.schema.host.includes = [
    den.aspects.disko._.diskoImport
    den.aspects.disko._.diskoClass
  ];

  den.aspects.disko = {
    # Create a `disko` class to house disko config
    _.diskoClass =
      {
        class ? "nixos",
        aspect-chain ? [ ],
        ...
      }:
      den._.forward {
        each = lib.singleton class;
        fromClass = _: "disko";
        intoClass = _: "nixos"; # Disko only supports NixOS
        intoPath = _: [ ]; # Forwards into root
        fromAspect = _: if aspect-chain != [ ] then lib.head aspect-chain else "";
      };
    # Import the disko module for NixOS
    _.diskoImport = _: {
      nixos.imports = [ inputs.disko.nixosModules.disko ];
    };
  };
}
