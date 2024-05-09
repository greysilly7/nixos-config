{
  config,
  lib,
  pkgs,
  inputs,
  sops,
  ...
}: {
  config = {
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    services.printing.drivers = [pkgs.gutenprint pkgs.gutenprintBin pkgs.hplip];
  };
}
