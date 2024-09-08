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

  home-manager.users.greysilly7 = {
    imports = [
      ../../homes/greysilly7_greypersonal
    ];
  };

  sops.age = {
    sshKeyPaths = [
      "/persist/etc/ssh/ssh_host_ed25519_key"
    ];
    keyFile = "/persist/var/lib/sops-nix/key.txt";
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
