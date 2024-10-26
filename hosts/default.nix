{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  mkHost = name: system:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          {networking.hostName = name;}
          inputs.lanzaboote.nixosModules.lanzaboote
          ./${name}
        ]
        ++ builtins.attrValues self.nixosModules;

      # This allows to easily access flake inputs and outputs
      # from nixos modules, so it's a little bit cleaner
      specialArgs = {
        inherit inputs;
        theme = import ../theme;
        flake = self;
      };
    };
in {
  greypersonal = mkHost "greypersonal" "x86_64-linux";
}
