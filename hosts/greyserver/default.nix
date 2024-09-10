{
  config,
  pkgs,
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

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];

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
      ${tailscale}/bin/tailscale up -authkey file://${config.sops.secrets.ts_srv_key.path}
    '';
  };
}
