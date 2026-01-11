{ lib, pkgs, ... }:
{
  imports = [
    ./users
    ./net
    ./packages/minimal.nix
  ];

  boot = {
    initrd.systemd.enable = true;
    kernelParams = [
      "kernel.core_pattern=/dev/null"
      "vm.swappiness=10"
    ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      timeout = lib.mkDefault 0;
    };
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  environment.etc.machine-id.text = "796f7520617265206175746973746963";
  time.timeZone = "America/Detroit";
  system.stateVersion = "25.11";
}
