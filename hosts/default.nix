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
  gaminglaptop = mkHost "gaminglaptop" "x86_64-linux";
}
