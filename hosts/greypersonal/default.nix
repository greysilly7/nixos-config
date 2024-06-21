{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
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

  hardware.opengl = {
    extraPackages = with pkgs; [vaapiIntel libva libvdpau-va-gl vaapiVdpau ocl-icd intel-compute-runtime];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
