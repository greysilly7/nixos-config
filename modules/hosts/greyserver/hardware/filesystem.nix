_:
{
  den.aspects.greyserver-filesystem = {
    disko = import ./_disko.nix;

    nixos.fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };

    swapDevices = [
      { device = "/dev/zvol/zroot/swap"; }
    ];
  };
}
