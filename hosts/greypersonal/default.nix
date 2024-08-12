{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    inputs.catppuccin.nixosModules.catppuccin
  ];

  home-manager.users.greysilly7 = {
    imports = [
      ../../homes/greysilly7_greypersonal
    ];
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  # MESA Git
  chaotic.mesa-git = {
    enable = false;
    extraPackages = with pkgs; [mesa_git.opencl intel-media-driver intel-ocl intel-vaapi-driver];
    extraPackages32 = with pkgs.pkgsi686Linux; [pkgs.mesa32_git.opencl intel-media-driver intel-vaapi-driver];
  };

  # KDE
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # VirtManager
  # Enable virtualization with qemu and virt-manager and add the admin user to the necessary groups
  users.users."greysilly7".extraGroups = ["kvm" "input" "libvirtd"];
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    win-spice
    win-virtio
    spice
    spice-gtk
    spice-protocol
  ];
  services.spice-vdagentd.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      # allowedBridges = ["wlo1
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
  };
  # Kernel
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # chaotic.scx.enable = true; # by default uses scx_rustland scheduler

  services.power-profiles-daemon.enable = false;
  services.fwupd.enable = true; # Enable fwupd service
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

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
  };
}
