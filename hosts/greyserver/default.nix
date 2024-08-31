{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  home-manager.users.greysilly7 = {
    imports = [
      ../../homes/greysilly7_greyserver
    ];
  };

  sops.age = {
    sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    keyFile = "/var/lib/sops-nix/key.txt";
  };

  services.fwupd.enable = true; # Enable fwupd service
}
