{
  inputs,
  config,
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

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey file://${config.sops.secrets.ts_laptop_key.path}
    '';
  };
}
