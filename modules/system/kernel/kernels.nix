{
  inputs,
  den,
  ...
}:
{
  # Flake inputs
  flake-file.inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  # Include regular kernel by default in all hosts
  den.schema.host.includes = [ den.aspects.kernel._.default ];

  den.aspects.kernel = {
    includes = [ den.aspects.kernel._.default ];

    # Regular NixOS kernel
    _.default =
      _:
      {
        nixos =
          {
            pkgs,
            lib,
            ...
          }:
          {
            boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
          };
      };

    # CachyOS kernel for NixOS
    _.cachyos =
      _:
      {
        nixos =
          {
            pkgs,
            lib,
            ...
          }:
          {
            nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
            nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
            nix.settings.trusted-public-keys = [
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            ];

            boot.kernelPackages = lib.mkOverride 900 pkgs.cachyosKernels.linuxPackages-cachyos-latest;

            # Swap ananicy rules to cachyos rules in case ananicy is enabled
            services.ananicy.rulesProvider = lib.mkDefault pkgs.ananicy-rules-cachyos;
          };
      };
  };
}
