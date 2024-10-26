{...}: {
  sops = {
    # Path to the default SOPS file
    defaultSopsFile = ../../secrets/secrets.yaml;

    age = {
      sshKeyPaths = [
        "/persist/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/persist/var/lib/sops-nix/key.txt";
      generateKey = true; # Generate a new key if not present
    };

    secrets = {
      # List of secrets managed by SOPS
      adguardhomewebpass = {};
      cf_acme = {};
      cftoken = {};
      github_ci_token = {};
      grey_pass = {};
      imagorenv = {};
      pocbot_token = {};
      ts_laptop_key = {};
      ts_srv_key = {};
      vaultwarden = {};
    };
  };
}
