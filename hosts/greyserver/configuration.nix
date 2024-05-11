{
  config,
  lib,
  pkgs,
  inputs,
  chaotic,
  sops,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ../../modules/common.nix
    # ./secureboot.nix
    ./sops.nix

    ../../modules/hardware/pipewire.nix
    ../../modules/hardware/power.nix

    ../../modules/services/zram.nix
    ../../modules/services/ssh.nix
    # ../../modules/services/nginx.nix
    ../../modules/services/podman.nix
    # ../../modules/services/cloudflared.nix
  ];

  networking.hostName = "greypersonal";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  environment.systemPackages = with pkgs; [inputs.alejandra.defaultPackage.${system}];

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users = {
    greysilly7 = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
      ];
      hashedPassword = "$y$j9T$9OOwsG.xmn05RX3SwVZRN1$j7ItlMfGtaOI/nSwBYoHkMHGx57cwV16zAmT6DQnOO1";
    };
  };

  nixpkgs.config.allowUnfree = lib.mkForce true;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Manual optimise storage: nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.05";
}
