{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  mkHost = name: system:
    nixpkgs.lib.nixosSystem {
      modules =
        [
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          }
          inputs.disko.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.spicetify-nix.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-facter-modules.nixosModules.facter
          inputs.chaotic.nixosModules.default
          # inputs.nixos-cosmic.nixosModules.default

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
  # greypersonal = mkHost "greypersonal" "x86_64-linux";
  gaminglaptop = mkHost "gaminglaptop" "x86_64-linux";
}
