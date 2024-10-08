{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./hardware-configuration.nix
    # ./disko.nix
  ];

  home-manager.users.greysilly7 = {
    imports = [
      ../../homes/greysilly7_greypersonal
    ];
  };

  sops.age = {
    sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    keyFile = "/var/lib/sops-nix/key.txt";
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  # KDE
  /*
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.power-profiles-daemon.enable = false;
  services.fwupd.enable = true; # Enable fwupd service
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  specialisation = {
    nvidia.configuration = {
      # Nvidia Configuration
      services.xserver.videoDrivers = ["nvidia"];
      hardware.opengl.enable = true;

      hardware.nvidia = {
        # Optionally, you may need to select the appropriate driver version for your specific GPU.

        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway

        modesetting.enable = true;
        # Use opensource drivers?
        open = false;
      };

      hardware.nvidia.prime = {
        sync.enable = true;

        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";

        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
  };
  */
}
