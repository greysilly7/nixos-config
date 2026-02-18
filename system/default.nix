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

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  security = {
    polkit.enable = true;
    sudo-rs.enable = true;
  };
  services.userborn.enable = true;
  services.openssh = {
    enable = true;
    settings.X11Forwarding = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = false;
    settings.UseDns = false;
    # unbind gnupg sockets if they exists
    settings.StreamLocalBindUnlink = true;

    # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
    settings.KexAlgorithms = [
      "mlkem768x25519-sha256"
      "sntrup761x25519-sha512"
      "sntrup761x25519-sha512@openssh.com"
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
    ];
  };

  programs.ssh.knownHosts = {
    "github.com".hostNames = [ "github.com" ];
    "github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    "gitlab.com".hostNames = [ "gitlab.com" ];
    "gitlab.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";

    "git.sr.ht".hostNames = [ "git.sr.ht" ];
    "git.sr.ht".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60";
  };

  environment.etc.machine-id.text = "796f7520617265206175746973746963";
  time.timeZone = lib.mkDefault "America/Detroit";
  system.stateVersion = "25.11";
}
