{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./users/greysilly7
    ./extra-substituters.nix
    ./secrets.nix
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
      systemd-boot.enable = true;
    };
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };

  };

  networking = {
    firewall = {
      enable = true;
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  environment.etc."resolv.conf" = lib.mkDefault {
    text = lib.concatStringsSep "\n" (
      lib.optionals (config.networking ? nameservers) (
        map (nameserver: "nameserver ${nameserver}") (config.networking.nameservers)
      )
      #++ lib.optionals (config.networking ? enableIPv6 && !config.networking.enableIPv6) [ "options no-aaaa" ]
      ++ lib.optionals (config.networking ? enableIPv6 && config.networking.enableIPv6) [
        "options single-request"
        "options single-request-reopen"
        "options inet6"
      ]
    );
  };

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = [
    pkgs.neofetch
    pkgs.pciutils
    pkgs.git
    pkgs.htop
    pkgs.kitty.terminfo
    pkgs.file
    pkgs.unzip
    pkgs.zip
    pkgs.brotli
    pkgs.curl
    pkgs.wget2
    pkgs.dnsutils
    pkgs.jq
    pkgs.tmux
  ];

  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "@wheel"
        "root"
      ];
      log-lines = 25;
      max-free = lib.mkDefault (3000 * 1024 * 1024);
      min-free = lib.mkDefault (512 * 1024 * 1024);
      builders-use-substitutes = true;
      connect-timeout = 5;
      fallback = true;
    };
  };
  nixpkgs = {
    config.allowUnfree = true;
  };

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
}
