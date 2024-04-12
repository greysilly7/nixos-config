{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options = {
    lanzaboote = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Lanzaboote.";
    };
  };

  config = {
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    boot.initrd.systemd.enable = true;
    boot.initrd.availableKernelModules = [ "tpm_crb" ];

    environment.systemPackages = with pkgs; [ sbctl ];
  };
}
