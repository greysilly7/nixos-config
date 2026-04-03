# Host disko config
{
  den.aspects.gaminglaptop = {
    disko = import ./_disko.nix; # Import raw disko config
    nixos.fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };
  };
}
