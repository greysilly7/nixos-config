{...}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      grey_pass = {};
      cftoken = {};
      vaultwarden = {};
      cf_acme = {};
      tailscale_srv_key = {};
      adguardhomewebpass = {};
    };
  };
}
