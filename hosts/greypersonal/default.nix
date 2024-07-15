{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  # MESA Git
  chaotic.mesa-git = {
    enable = true;
    extraPackages = with pkgs; [mesa_git.opencl intel-media-driver intel-ocl intel-vaapi-driver];
    extraPackages32 = with pkgs.pkgsi686Linux; [pkgs.mesa32_git.opencl intel-media-driver intel-vaapi-driver];
  };

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
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

  /*
  hardware.graphics = {
    extraPackages = with pkgs; [vaapiIntel libva libvdpau-va-gl vaapiVdpau ocl-icd intel-compute-runtime];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  */
}
